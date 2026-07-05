class Brand < ApplicationRecord
  has_many :materials
  has_many :filaments
end
