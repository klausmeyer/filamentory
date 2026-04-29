require "rails_helper"

RSpec.describe "Admin spools search", type: :request do
  fixtures :users, :brands, :materials, :variants, :products, :filaments, :spools

  let(:user) { users(:admin) }
  let(:filament_black) { filaments(:filament_black) }
  let(:filament_white) { filaments(:filament_white) }

  before do
    sign_in user
  end

  it "shows only records with matching filament name" do
    spools(:spool_white)
    spools(:spool_black)

    get "/admin/spools", params: { q: "white" }

    expect(response).to have_http_status(:ok)

    expect(response.body).to include "Product A - White"
    expect(response.body).not_to include "Product A - Black"
  end
end
