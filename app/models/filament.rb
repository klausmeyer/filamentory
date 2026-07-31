class Filament < ApplicationRecord
  belongs_to :product

  has_many :spools, dependent: :restrict_with_exception

  validates :product_id, presence: true
  validates :color_name, presence: true
  validates :color_hex, presence: true
  validates :natural_color_sort_key, presence: true

  before_validation :sync_natural_color_sort_key

  def self.sorted_by_name
    eager_load(product: [ :brand, :material, :variant ]).order(
      brands:    { name: :asc },
      materials: { name: :asc },
      variants:  { name: :asc },
      filaments: { color_name: :asc }
    )
  end

  def name
    "#{product.brand.name} #{product.material.name} #{product.variant.name} - #{color_name}"
  end

  private

  def sync_natural_color_sort_key
    self.natural_color_sort_key = NaturalColorSortKey.for(color_hex: color_hex, color_name: color_name)
  end
end
