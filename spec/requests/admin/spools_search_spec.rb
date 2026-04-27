require "rails_helper"

RSpec.describe "Admin spools search", type: :request do
  let!(:user) do
    User.create!(email: "admin@example.com", password: "password123", password_confirmation: "password123")
  end

  let!(:brand) { Brand.create!(name: "Brand A") }
  let!(:material) { Material.create!(name: "PLA") }
  let!(:variant) { Variant.create!(name: "Standard") }
  let!(:product) do
    Product.create!(name: "Product A", brand:, material:, variant:, weight_grams: 1000, spool_weight_grams: 200)
  end

  let!(:filament_black) { Filament.create!(product:, color_name: "Black", color_hex: "#000000") }
  let!(:filament_white) { Filament.create!(product:, color_name: "White", color_hex: "#FFFFFF") }

  before do
    sign_in user
  end

  it "shows only records with matching filament name" do
    Spool.create!(filament: filament_white, ovp: false, refill_only: false, gross_weight_grams: 1000)
    Spool.create!(filament: filament_black, ovp: false, refill_only: false, gross_weight_grams: 1000)

    get "/admin/spools", params: { q: "white" }

    expect(response).to have_http_status(:ok)

    expect(response.body).to include "Product A - White"
    expect(response.body).not_to include "Product A - Black"
  end
end
