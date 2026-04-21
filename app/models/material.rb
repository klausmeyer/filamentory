class Material < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
