data = JSON.load_file("/Users/meyer/filamentory.json", symbolize_names: true)

data.each do |spool|
  Spool.find_or_create_by!(
    variant: Variant.find_or_create_by!(
      name: spool[:color_name],
      filament: Filament.find_or_create_by!(
        name: "#{spool[:material]} #{spool[:variant]}",
        brand: Brand.find_or_create_by!(name: spool[:brand]),
        material: Material.find_or_create_by!(name: spool[:material])
      ),
      weight_net: spool[:weight_grams],
      weight_tare: spool[:spool_weight_grams],
      color: spool[:color_hex]&.upcase
    ),
    remaining_weight_gross: spool[:gross_weight_grams] || spool[:weight_grams],
    ovp: spool[:ovp],
    refill: spool[:refill_only]
  )
end
