require "rails_helper"

RSpec.describe "OIDC UI", type: :request do
  fixtures :users, :user_identities

  around do |example|
    original_provider = ENV["OIDC_PROVIDER"]
    original_omniauth_config = Devise.omniauth_configs[:openid_connect]
    example.run
  ensure
    ENV["OIDC_PROVIDER"] = original_provider
    if original_omniauth_config
      Devise.omniauth_configs[:openid_connect] = original_omniauth_config
    else
      Devise.omniauth_configs.delete(:openid_connect)
    end
  end

  it "shows the default OIDC control on the Trestle login page" do
    get "/admin/login"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("OIDC not configured")
  end

  it "uses OIDC_PROVIDER for the login page label" do
    ENV["OIDC_PROVIDER"] = "Authentik"

    get "/admin/login"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Authentik not configured")
    expect(response.body).not_to include("OIDC not configured")
  end

  it "renders configured login as a token-bearing POST form" do
    original_forgery_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    Devise.omniauth_configs[:openid_connect] = Object.new

    get "/admin/login"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("method=\"post\" action=\"/users/auth/openid_connect\"")
    expect(response.body).to include("data-turbo=\"false\"")
    expect(response.body).to include("name=\"authenticity_token\"")
    expect(response.body).not_to include("data-turbo-method=\"post\"")
  ensure
    ActionController::Base.allow_forgery_protection = original_forgery_protection
  end

  it "styles the default Devise login page" do
    Devise.omniauth_configs[:openid_connect] = Object.new

    get new_user_session_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("auth-page")
    expect(response.body).to include("auth-card")
    expect(response.body).to include("class=\"form-control\"")
    expect(response.body).to include("class=\"btn btn-primary btn-lg w-100\"")
    expect(response.body).to include("Forgot password?")
    expect(response.body).to include("Sign in with OIDC")
  end

  it "shows default OIDC status in the Users admin" do
    sign_in users(:admin)

    get "/admin/auth/users"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("OIDC")
    expect(response.body).to include("Linked")
  end

  it "uses OIDC_PROVIDER for the Users admin status column" do
    ENV["OIDC_PROVIDER"] = "Authentik"
    sign_in users(:admin)

    get "/admin/auth/users"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Authentik")
    expect(response.body).to include("Linked")
  end

  it "does not emit Turbo method links for OIDC actions" do
    get "/admin/login"

    expect(response.body).not_to include("data-turbo-method=\"post\"")
  end

  it "shows OIDC status on the current account form" do
    sign_in users(:admin)

    get "/admin/auth/account"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("OIDC Account")
    expect(response.body).to include("admin@example.com")
    expect(response.body).to include("Unlink OIDC")
    expect(response.body).to include("href=\"/users/oidc_link/unlink\"")
    expect(response.body).not_to include("data-turbo-method=\"delete\"")
    expect(response.body).not_to include("method=\"post\" action=\"/users/oidc_link\"")
  end

  it "links unlinked users from their account form to the OIDC connect page" do
    users(:admin).user_identities.destroy_all
    sign_in users(:admin)
    Devise.omniauth_configs[:openid_connect] = Object.new

    get "/admin/auth/account"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Connect OIDC")
    expect(response.body).to include("/users/oidc_link/new")
  end

  it "renders a token-bearing POST form on the OIDC connect page" do
    original_forgery_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    users(:admin).user_identities.destroy_all
    sign_in users(:admin)
    Devise.omniauth_configs[:openid_connect] = Object.new

    get new_users_oidc_link_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("method=\"post\" action=\"/users/auth/openid_connect\"")
    expect(response.body).to include("data-turbo=\"false\"")
    expect(response.body).to include("name=\"authenticity_token\"")
  ensure
    ActionController::Base.allow_forgery_protection = original_forgery_protection
  end

  it "renders a standalone unlink confirmation form" do
    original_forgery_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    sign_in users(:admin)

    get unlink_users_oidc_link_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Unlink OIDC")
    expect(response.body).to include("method=\"post\" action=\"/users/oidc_link\"")
    expect(response.body).to include("name=\"_method\"")
    expect(response.body).to include("value=\"delete\"")
    expect(response.body).to include("name=\"authenticity_token\"")
    expect(response.body).to include("data-turbo=\"false\"")
  ensure
    ActionController::Base.allow_forgery_protection = original_forgery_protection
  end
end
