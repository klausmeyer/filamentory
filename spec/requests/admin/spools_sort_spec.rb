require "rails_helper"

RSpec.describe "Admin spools sorting", type: :request do
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

  it "does not error when sorting spools by name" do
    Spool.create!(filament: filament_white, ovp: false, refill_only: false, gross_weight_grams: 1000)
    Spool.create!(filament: filament_black, ovp: false, refill_only: false, gross_weight_grams: 1000)

    get "/admin/spools", params: { sort: "name", order: "asc" }

    expect(response).to have_http_status(:ok)

    index_black = response.body.index(filament_black.name)
    index_white = response.body.index(filament_white.name)

    expect(index_black).to be_present
    expect(index_white).to be_present
    expect(index_black).to be < index_white
  end

  it "does not error when sorting spools by gross weight" do
    Spool.create!(filament: filament_white, ovp: false, refill_only: false, gross_weight_grams: 900)
    Spool.create!(filament: filament_black, ovp: false, refill_only: false, gross_weight_grams: 1100)

    get "/admin/spools", params: { sort: "gross_weight_grams", order: "asc" }

    expect(response).to have_http_status(:ok)

    index_white = response.body.index(filament_white.name)
    index_black = response.body.index(filament_black.name)

    expect(index_white).to be_present
    expect(index_black).to be_present
    expect(index_white).to be < index_black
  end

  it "does not error when sorting spools by net weight" do
    Spool.create!(filament: filament_white, ovp: false, refill_only: false, gross_weight_grams: 900) # net 700
    Spool.create!(filament: filament_black, ovp: false, refill_only: false, gross_weight_grams: 1300) # net 1100

    get "/admin/spools", params: { sort: "remaining_weight_grams", order: "desc" }

    expect(response).to have_http_status(:ok)

    index_black = response.body.index(filament_black.name)
    index_white = response.body.index(filament_white.name)

    expect(index_black).to be_present
    expect(index_white).to be_present
    expect(index_black).to be < index_white
  end

  it "defaults to sorting spools by updated_at desc" do
    spool_older = Spool.create!(filament: filament_white, ovp: false, refill_only: false, gross_weight_grams: 1000)
    spool_newer = Spool.create!(filament: filament_black, ovp: false, refill_only: false, gross_weight_grams: 1000)

    spool_older.update_columns(updated_at: 2.days.ago, created_at: 2.days.ago)
    spool_newer.update_columns(updated_at: 1.day.ago, created_at: 1.day.ago)

    get "/admin/spools"

    expect(response).to have_http_status(:ok)

    index_newer = response.body.index(filament_black.name)
    index_older = response.body.index(filament_white.name)

    expect(index_newer).to be_present
    expect(index_older).to be_present
    expect(index_newer).to be < index_older
  end
end
