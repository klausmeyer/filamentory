class Spool < ApplicationRecord
  has_paper_trail

  belongs_to :variant
  has_one :filament, through: :variant
  has_one :brand, through: :filament
  has_one :material, through: :filament

  def self.sorted_by_filament
    eager_load(:variant, :filament, :brand, :material).order(
      brands:    { name: :asc },
      materials: { name: :asc },
      filaments: { name: :asc },
      variants:  { color: :asc },
      spools:    { remaining_weight_gross: :asc }
    )
  end

  def remaining_weight_net
    remaining_weight_gross - variant.weight_tare
  end
end
