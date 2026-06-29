# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_email = ENV.fetch("SEED_ADMIN_EMAIL", "admin@example.com")
admin_password = ENV["SEED_ADMIN_PASSWORD"]

if (Rails.env.development? || Rails.env.test?) && admin_password.blank?
  admin_password = "password123"
end

if admin_password.present?
  user = User.find_or_initialize_by(email: admin_email)

  if user.new_record?
    user.password = admin_password
    user.password_confirmation = admin_password
    user.save!

    puts "Seeded admin user: #{user.email}"
  else
    puts "Admin user already exists: #{user.email}"
  end
else
  puts "Skipping admin user seed: set SEED_ADMIN_PASSWORD to enable"
end

# Domain seed data (brands/materials/variants/products/filaments/spools)

bambu = Brand.find_or_create_by!(name: "Bambu Lab")
elegoo = Brand.find_or_create_by!(name: "Elegoo")

pla = Material.find_or_create_by!(name: "PLA")
petg = Material.find_or_create_by!(name: "PETG")
Material.find_or_create_by!(name: "TPU") # Extra material (not used by default data)

basic = Variant.find_or_create_by!(name: "Basic")
matte = Variant.find_or_create_by!(name: "Matte")
Variant.find_or_create_by!(name: "Silk")

bambu_pla_basic =
  Product.find_or_create_by!(name: "Bambu Lab - PLA Basic") do |p|
    p.brand = bambu
    p.material = pla
    p.variant = basic
    p.weight_grams = 1_000
    p.spool_weight_grams = 250
  end

bambu_pla_matte =
  Product.find_or_create_by!(name: "Bambu Lab - PLA Matte") do |p|
    p.brand = bambu
    p.material = pla
    p.variant = matte
    p.weight_grams = 1_000
    p.spool_weight_grams = 250
  end

elegoo_pla_basic =
  Product.find_or_create_by!(name: "Elegoo - PLA Basic") do |p|
    p.brand = elegoo
    p.material = pla
    p.variant = basic
    p.weight_grams = 1_000
    p.spool_weight_grams = 175
  end

Product.find_or_create_by!(name: "Elegoo - PLA Matte") do |p|
  p.brand = elegoo
  p.material = pla
  p.variant = matte
  p.weight_grams = 1_000
  p.spool_weight_grams = 175
end

elegoo_rapid_petg =
  Product.find_or_create_by!(name: "Elegoo - Rapid PETG") do |p|
    p.brand = elegoo
    p.material = petg
    p.variant = basic
    p.weight_grams = 1_000
    p.spool_weight_grams = 175
  end

filament_for = lambda do |product:, color_name:, color_hex:, mpn: nil|
  Filament
    .find_or_initialize_by(product: product, color_name: color_name)
    .tap do |filament|
      filament.color_hex = color_hex
      filament.mpn = mpn
      filament.save! if filament.changed?
    end
end

bambu_pla_basic_black =
  filament_for.call(
    product: bambu_pla_basic,
    color_name: "Black",
    color_hex: "#000000",
    mpn: "BAMBU-PLA-BASIC-BLACK"
  )
bambu_pla_basic_grey =
  filament_for.call(
    product: bambu_pla_basic,
    color_name: "Grey",
    color_hex: "#c2c2c2",
    mpn: "BAMBU-PLA-BASIC-GREY"
  )

[
  [ "Ash Grey", "#909396", "BAMBU-PLA-MATTE-ASH-GREY" ],
  [ "Charcoal", "#000000", "BAMBU-PLA-MATTE-CHARCOAL" ],
  [ "Dark Red", "#b2353b", "BAMBU-PLA-MATTE-DARK-RED" ],
  [ "Ivory White", "#ffffff", "BAMBU-PLA-MATTE-IVORY-WHITE" ],
  [ "Mandarin Orange", "#f88d58", "BAMBU-PLA-MATTE-MANDARIN-ORANGE" ],
  [ "Marine Blue", "#006eb7", "BAMBU-PLA-MATTE-MARINE-BLUE" ]
].each do |(color_name, color_hex, mpn)|
  filament_for.call(product: bambu_pla_matte, color_name: color_name, color_hex: color_hex, mpn: mpn)
end

[
  [ "Black", "#000000", "ELEGOO-PLA-BASIC-BLACK" ],
  [ "Dark Blue", "#2240af", "ELEGOO-PLA-BASIC-DARK-BLUE" ],
  [ "Neon Green", "#08e327", "ELEGOO-PLA-BASIC-NEON-GREEN" ],
  [ "Translucent", "#f3f3f3", "ELEGOO-PLA-BASIC-TRANSLUCENT" ]
].each do |(color_name, color_hex, mpn)|
  filament_for.call(product: elegoo_pla_basic, color_name: color_name, color_hex: color_hex, mpn: mpn)
end

[
  [ "Red", "#ea140e", "ELEGOO-RAPID-PETG-RED" ],
  [ "White", "#ffffff", "ELEGOO-RAPID-PETG-WHITE" ]
].each do |(color_name, color_hex, mpn)|
  filament_for.call(product: elegoo_rapid_petg, color_name: color_name, color_hex: color_hex, mpn: mpn)
end

Spool.find_or_create_by!(
  filament: bambu_pla_basic_black,
  ovp: false,
  refill_only: false,
  gross_weight_grams: 714,
  comment: nil
)

Spool.find_or_create_by!(
  filament: bambu_pla_basic_grey,
  ovp: true,
  refill_only: false,
  gross_weight_grams: nil,
  comment: nil
)
