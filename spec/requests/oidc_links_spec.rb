require "rails_helper"

RSpec.describe "OIDC account links", type: :request do
  fixtures :users, :user_identities

  it "shows an unlink confirmation page" do
    sign_in users(:admin)

    get unlink_users_oidc_link_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Unlink OIDC")
    expect(response.body).to include(users(:admin).oidc_identity.email)
  end

  it "unlinks the current user's OIDC identity" do
    sign_in users(:admin)

    expect {
      delete users_oidc_link_path
    }.to change { users(:admin).user_identities.reload.count }.by(-1)

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("OIDC account unlinked.")
  end

  it "reports when the current user has no OIDC identity to unlink" do
    users(:admin).user_identities.destroy_all
    sign_in users(:admin)

    expect {
      delete users_oidc_link_path
    }.not_to change(UserIdentity, :count)

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("No linked OIDC account was found.")
  end
end
