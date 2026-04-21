class Filament < ApplicationRecord
  belongs_to :product

  has_many :spools, dependent: :restrict_with_exception

  before_validation :sync_name

  validates :product_id, presence: true
  validates :name, presence: true
  validates :color_name, presence: true
  validates :color_hex, presence: true

  def computed_name
    product_name =
      if association(:product).loaded?
        product&.name
      else
        Product.where(id: product_id).pick(:name)
      end

    return if product_name.blank? || color_name.blank?

    "#{product_name} - #{color_name}"
  end

  def to_s
    name
  end

  private

  def sync_name
    return if product_id.blank? || color_name.blank?

    self.name = computed_name
  end
end
