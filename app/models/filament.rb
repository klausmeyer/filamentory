class Filament < ApplicationRecord
  belongs_to :product

  has_many :spools, dependent: :restrict_with_exception

  validates :product_id, presence: true
  validates :color_name, presence: true
  validates :color_hex, presence: true

  def self.sorted_by_name
    eager_load(product: [ :brand, :material, :variant ]).order(
      brands:    { name: :asc },
      materials: { name: :asc },
      variants:  { name: :asc },
    )
  end

  def name
    "#{product.brand.name} #{product.material.name} #{product.variant.name}"
  end
end
