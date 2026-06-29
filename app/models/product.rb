class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :material
  belongs_to :variant

  has_many :filaments, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :diameter, presence: true, numericality: { greater_than: 0 }
  validates :weight_grams, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :spool_weight_grams, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def article_no
    nil
  end

  def to_s
    name
  end
end
