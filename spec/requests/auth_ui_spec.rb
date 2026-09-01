require "rails_helper"

RSpec.describe "Auth UI", type: :request do
  fixtures :users

  it "links the public login button to the Devise login page" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(%(href="#{new_user_session_path}"))
    expect(response.body).not_to include(%(href="/admin/login"))
  end

  it "links signed-in users to their account from the dropdown" do
    sign_in users(:admin)

    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("My Account")
    expect(response.body).to include(%(href="#{trestle.auth_account_admin_path}"))
  end
end
