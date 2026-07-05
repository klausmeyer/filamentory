class Variant < ApplicationRecord
  belongs_to :filament
  has_many :spools
end
