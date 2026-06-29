require "json"
require "net/http"

module SpoolmanDb
  class ImportFilaments
    Result = Data.define(
      :brands_created,
      :materials_created,
      :variants_created,
      :products_created,
      :products_updated,
      :filaments_created,
      :filaments_updated
    )

    def initialize(url:, http_fetcher: nil)
      @url = url
      @http_fetcher = http_fetcher || method(:fetch_url)
      @counts = Hash.new(0)
    end

    def call
      payload = JSON.parse(@http_fetcher.call(raw_url))

      ActiveRecord::Base.transaction do
        import_payload(payload)
      end

      Result.new(
        brands_created: @counts[:brands_created],
        materials_created: @counts[:materials_created],
        variants_created: @counts[:variants_created],
        products_created: @counts[:products_created],
        products_updated: @counts[:products_updated],
        filaments_created: @counts[:filaments_created],
        filaments_updated: @counts[:filaments_updated]
      )
    end

    private

    attr_reader :url

    def import_payload(payload)
      manufacturer = payload.fetch("manufacturer").to_s.strip
      raise ArgumentError, "SpoolmanDB payload is missing manufacturer" if manufacturer.blank?

      brand = find_or_create_brand(manufacturer)

      Array(payload.fetch("filaments")).each do |filament_data|
        import_filament_group(brand, filament_data)
      end
    end

    def import_filament_group(brand, filament_data)
      material = find_or_create_material(filament_data.fetch("material").to_s.strip)
      variant = find_or_create_variant(variant_name_for(filament_data))
      weights = Array(filament_data.fetch("weights"))
      diameters = Array(filament_data.fetch("diameters"))

      weights.each do |weight_data|
        diameters.each do |diameter|
          product = import_product(
            brand: brand,
            material: material,
            variant: variant,
            weight_data: weight_data,
            diameter: diameter,
            include_weight_suffix: weights.size > 1 || weight_data["weight"].to_i != 1_000,
            include_diameter_suffix: diameters.size > 1 || diameter.to_d != 1.75.to_d
          )

          Array(filament_data.fetch("colors")).each do |color_data|
            import_filament(product, color_data)
          end
        end
      end
    end

    def import_product(brand:, material:, variant:, weight_data:, diameter:, include_weight_suffix:, include_diameter_suffix:)
      product_name = product_name_for(
        brand: brand,
        material: material,
        variant: variant,
        weight_data: weight_data,
        diameter: diameter,
        include_weight_suffix: include_weight_suffix,
        include_diameter_suffix: include_diameter_suffix
      )
      product = Product.find_or_initialize_by(name: product_name)
      was_new = product.new_record?

      product.assign_attributes(
        brand: brand,
        material: material,
        variant: variant,
        diameter: diameter,
        weight_grams: weight_data.fetch("weight"),
        spool_weight_grams: weight_data.fetch("spool_weight", 0)
      )
      product.save! if product.changed?

      if was_new
        @counts[:products_created] += 1
      elsif product.previous_changes.present?
        @counts[:products_updated] += 1
      end

      product
    end

    def import_filament(product, color_data)
      color_name = color_data.fetch("name").to_s.strip
      filament = Filament.find_or_initialize_by(product: product, color_name: color_name)
      was_new = filament.new_record?

      filament.color_hex = color_hex_for(color_data)
      filament.save! if filament.changed?

      if was_new
        @counts[:filaments_created] += 1
      elsif filament.previous_changes.present?
        @counts[:filaments_updated] += 1
      end

      filament
    end

    def find_or_create_brand(name)
      find_or_create_lookup(Brand, name, :brands_created)
    end

    def find_or_create_material(name)
      find_or_create_lookup(Material, name, :materials_created)
    end

    def find_or_create_variant(name)
      find_or_create_lookup(Variant, name, :variants_created)
    end

    def find_or_create_lookup(model, name, counter)
      raise ArgumentError, "#{model.name} name is blank" if name.blank?

      record = model.find_or_initialize_by(name: name)
      @counts[counter] += 1 if record.new_record?
      record.save! if record.new_record?
      record
    end

    def variant_name_for(filament_data)
      template_variant = filament_data.fetch("name").to_s.gsub("{color_name}", "").squish
      return template_variant if template_variant.present?

      return filament_data["pattern"].to_s.titleize if filament_data["pattern"].present?
      return filament_data["finish"].to_s.titleize if filament_data["finish"].present?
      return "Glow" if filament_data["glow"]
      return "Translucent" if filament_data["translucent"]

      "Basic"
    end

    def product_name_for(brand:, material:, variant:, weight_data:, diameter:, include_weight_suffix:, include_diameter_suffix:)
      name = "#{brand.name} - #{material.name} #{variant.name}"
      name = "#{name} #{format_diameter(diameter)}mm" if include_diameter_suffix
      return name unless include_weight_suffix

      "#{name} #{weight_data.fetch("weight")}g"
    end

    def color_hex_for(color_data)
      hex = color_data["hex"].presence || Array(color_data["hexes"]).first
      raise ArgumentError, "Color #{color_data["name"].inspect} is missing hex data" if hex.blank?

      normalized = hex.to_s.delete_prefix("#")
      "##{normalized}"
    end

    def format_diameter(diameter)
      BigDecimal(diameter.to_s).to_s("F").sub(/\.?0+\z/, "")
    end

    def raw_url
      uri = URI.parse(url)

      if uri.host == "github.com" && uri.path.include?("/blob/")
        path = uri.path.sub(%r{\A/}, "").sub("/blob/", "/")
        return "https://raw.githubusercontent.com/#{path}"
      end

      url
    rescue URI::InvalidURIError => e
      raise ArgumentError, "Invalid URL: #{e.message}"
    end

    def fetch_url(fetch_url)
      uri = URI.parse(fetch_url)
      raise ArgumentError, "Only HTTP and HTTPS URLs are supported" unless uri.is_a?(URI::HTTP)

      response =
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 30) do |http|
          http.get(uri.request_uri)
        end

      raise ArgumentError, "Could not fetch #{fetch_url}: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    rescue URI::InvalidURIError => e
      raise ArgumentError, "Invalid URL: #{e.message}"
    end
  end
end
