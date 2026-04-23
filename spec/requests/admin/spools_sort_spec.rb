require "rails_helper"

RSpec.describe "Admin spools sorting", type: :request do
  it "does not error when sorting spools by name" do
    user = User.create!(email: "admin@example.com", password: "password123", password_confirmation: "password123")
    sign_in user

    brand = Brand.create!(name: "Brand A")
    material = Material.create!(name: "PLA")
    variant = Variant.create!(name: "Standard")
    product = Product.create!(name: "Product A", brand:, material:, variant:, weight_grams: 1000, spool_weight_grams: 200)

    filament_a = Filament.create!(product:, color_name: "Black", color_hex: "#000000")
    filament_b = Filament.create!(product:, color_name: "White", color_hex: "#FFFFFF")

    Spool.create!(filament: filament_b, ovp: false, refill_only: false, gross_weight_grams: 1000)
    Spool.create!(filament: filament_a, ovp: false, refill_only: false, gross_weight_grams: 1000)

    get "/admin/spools", params: { sort: "name", order: "asc" }

    expect(response).to have_http_status(:ok)

    index_a = response.body.index(filament_a.name)
    index_b = response.body.index(filament_b.name)

    expect(index_a).to be_present
    expect(index_b).to be_present
    expect(index_a).to be < index_b
  end
end
