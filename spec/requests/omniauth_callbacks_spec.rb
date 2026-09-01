require "rails_helper"

RSpec.describe "OIDC OmniAuth callbacks", type: :request do
  fixtures :users, :user_identities

  around do |example|
    OmniAuth.config.test_mode = true
    original_mock_auth = OmniAuth.config.mock_auth[:openid_connect]
    example.run
  ensure
    OmniAuth.config.mock_auth[:openid_connect] = original_mock_auth
    OmniAuth.config.test_mode = false
  end

  it "signs in a user with an existing linked identity" do
    auth = auth_hash(
      uid: user_identities(:admin_oidc).uid,
      email: users(:admin).email
    )

    post user_openid_connect_omniauth_callback_path, env: { "omniauth.auth" => auth }

    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(request.env["warden"].user(:user)).to eq(users(:admin))
  end

  it "links an OIDC identity to the current user" do
    sign_in users(:admin)

    auth = auth_hash(
      uid: "new-oidc-sub",
      email: users(:admin).email
    )

    expect {
      post user_openid_connect_omniauth_callback_path, env: { "omniauth.auth" => auth }
    }.to change { users(:admin).user_identities.count }.by(1)

    identity = users(:admin).user_identities.find_by(uid: "new-oidc-sub")
    expect(identity).to have_attributes(
      provider: "openid_connect",
      email: users(:admin).email,
      email_verified: true
    )
  end

  it "links a verified email match when no session exists" do
    auth = auth_hash(
      uid: "verified-email-sub",
      email: users(:admin).email
    )

    expect {
      post user_openid_connect_omniauth_callback_path, env: { "omniauth.auth" => auth }
    }.to change { users(:admin).user_identities.count }.by(1)

    follow_redirect!
    expect(request.env["warden"].user(:user)).to eq(users(:admin))
  end

  it "refuses an unverified email match when no session exists" do
    auth = auth_hash(
      uid: "unverified-email-sub",
      email: users(:admin).email,
      email_verified: false
    )

    expect {
      post user_openid_connect_omniauth_callback_path, env: { "omniauth.auth" => auth }
    }.not_to change(UserIdentity, :count)

    expect(response).to redirect_to(new_user_session_path)
  end

  def auth_hash(uid:, email:, email_verified: true)
    OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: uid,
      info: {
        email: email,
        email_verified: email_verified,
        name: "Admin User"
      },
      extra: {
        raw_info: {
          sub: uid,
          iss: "https://idp.example.test",
          email: email,
          email_verified: email_verified
        }
      }
    )
  end
end
