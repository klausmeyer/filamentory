Statistic = Struct.new(
  :spools_total_count,
  :spools_total_weight,
  :by_brand,
  :by_material,
)

class Statistic
  class << self
    def all
      new(
        spools_total_count:  Spool.count,
        spools_total_weight: Spool.all.sum(&:remaining_weight_grams),
        by_brand:            by_brand,
        by_material:         by_material
      )
    end

    private

    def by_brand
      Spool
        .joins(filament: { product: :brand })
        .group(brands: :name)
        .select("brands.name AS name, COUNT(*) AS count, SUM(remaining_weight_grams) AS weight")
        .order(brands: { name: :asc })
    end

    def by_material
      Spool
        .joins(filament: { product: :material })
        .group(materials: :name)
        .select("materials.name AS name, COUNT(*) AS count, SUM(remaining_weight_grams) AS weight")
        .order(materials: { name: :asc })
    end
  end
end
