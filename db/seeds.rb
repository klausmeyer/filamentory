# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Brand (Bambu Lab) -> Material (PLA) -> Filament (PLA Basic) -> Variant (Pumpkin Orange)

User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "12345678"
  user.save!
end

[
  {
    brand:       "Bambu Lab",
    material:    "PLA",
    filament:    "PLA Basic",
    variant:     "Pumpkin Orange",
    weight_net:  1000,
    weight_tare: 250,
    color:       "#FF9016"
  },
  {
    brand:       "Elegoo",
    material:    "PLA",
    filament:    "PLA",
    variant:     "Black",
    weight_net:  1000,
    weight_tare: 159,
    color:       "#000000"
  }
].each do |item|
  pp item

  variant = Variant.find_or_create_by!(
    name: item[:variant],
    filament: Filament.find_or_create_by!(
      name: item[:filament],
      brand: Brand.find_or_create_by!(name: item[:brand]),
      material: Material.find_or_create_by!(name: item[:material])
    ),
    weight_net: item[:weight_net],
    weight_tare: item[:weight_tare],
    color: item[:color]
  )

  next if variant.spools.any?

  Spool.create!(
    variant: variant,
    remaining_weight_gross: 750
  )

  Spool.create!(
    variant: variant,
    remaining_weight_gross: 1000
  )
end
