require "rails_helper"

RSpec.describe "Admin spools sorting", type: :request do
  fixtures :users, :brands, :materials, :variants, :products, :filaments, :spools

  let(:user) { users(:admin) }
  let(:filament_black) { filaments(:filament_black) }
  let(:filament_white) { filaments(:filament_white) }
  let(:spool_black) { spools(:spool_black) }
  let(:spool_white) { spools(:spool_white) }

  before do
    sign_in user
  end

  it "does not error when sorting spools by name" do
    spool_white
    spool_black

    get "/admin/spools", params: { sort: "name", order: "asc" }

    expect(response).to have_http_status(:ok)

    index_black = response.body.index(filament_black.name)
    index_white = response.body.index(filament_white.name)

    expect(index_black).to be_present
    expect(index_white).to be_present
    expect(index_black).to be < index_white
  end

  it "does not error when sorting spools by gross weight" do
    spool_white.update!(gross_weight_grams: 900)
    spool_black.update!(gross_weight_grams: 1100)

    get "/admin/spools", params: { sort: "gross_weight_grams", order: "asc" }

    expect(response).to have_http_status(:ok)

    index_white = response.body.index(filament_white.name)
    index_black = response.body.index(filament_black.name)

    expect(index_white).to be_present
    expect(index_black).to be_present
    expect(index_white).to be < index_black
  end

  it "does not error when sorting spools by net weight" do
    spool_white.update!(gross_weight_grams: 900) # net 700
    spool_black.update!(gross_weight_grams: 1300) # net 1100

    get "/admin/spools", params: { sort: "remaining_weight_grams", order: "desc" }

    expect(response).to have_http_status(:ok)

    index_black = response.body.index(filament_black.name)
    index_white = response.body.index(filament_white.name)

    expect(index_black).to be_present
    expect(index_white).to be_present
    expect(index_black).to be < index_white
  end

  it "defaults to sorting spools by updated_at desc" do
    spool_white.update_columns(updated_at: 2.days.ago, created_at: 2.days.ago)
    spool_black.update_columns(updated_at: 1.day.ago, created_at: 1.day.ago)

    get "/admin/spools"

    expect(response).to have_http_status(:ok)

    index_newer = response.body.index(filament_black.name)
    index_older = response.body.index(filament_white.name)

    expect(index_newer).to be_present
    expect(index_older).to be_present
    expect(index_newer).to be < index_older
  end
end
