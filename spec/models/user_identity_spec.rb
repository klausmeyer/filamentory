require "rails_helper"

RSpec.describe UserIdentity, type: :model do
  fixtures :users, :user_identities

  it "requires a provider" do
    identity = UserIdentity.new(uid: "subject", user: users(:admin))

    expect(identity).not_to be_valid
    expect(identity.errors[:provider]).to be_present
  end

  it "requires a uid" do
    identity = UserIdentity.new(provider: "openid_connect", user: users(:admin))

    expect(identity).not_to be_valid
    expect(identity.errors[:uid]).to be_present
  end

  it "does not allow the same uid for the same provider twice" do
    identity = UserIdentity.new(
      user: users(:admin),
      provider: "openid_connect",
      uid: user_identities(:admin_oidc).uid
    )

    expect(identity).not_to be_valid
    expect(identity.errors[:uid]).to be_present
  end

  it "extracts attributes from an OmniAuth auth hash" do
    auth = OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: "subject",
      info: {
        email: "admin@example.com",
        email_verified: true,
        name: "Admin User"
      },
      extra: {
        raw_info: {
          iss: "https://idp.example.test"
        }
      }
    )

    expect(described_class.attributes_from_auth(auth)).to include(
      provider: "openid_connect",
      uid: "subject",
      issuer: "https://idp.example.test",
      email: "admin@example.com",
      email_verified: true,
      name: "Admin User"
    )
  end

  it "defaults a missing email verification claim to false" do
    auth = OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: "subject",
      info: {
        email: "admin@example.com"
      },
      extra: {
        raw_info: {}
      }
    )

    expect(described_class.attributes_from_auth(auth)).to include(
      email_verified: false
    )
  end

  it "defaults a null email verification claim to false" do
    auth = OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: "subject",
      info: {
        email: "admin@example.com",
        email_verified: nil
      },
      extra: {
        raw_info: {}
      }
    )

    expect(described_class.attributes_from_auth(auth)).to include(
      email_verified: false
    )
  end

  it "keeps an explicit false email verification claim" do
    auth = OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: "subject",
      info: {
        email: "admin@example.com",
        email_verified: false
      },
      extra: {
        raw_info: {
          email_verified: true
        }
      }
    )

    expect(described_class.attributes_from_auth(auth)).to include(
      email_verified: false
    )
  end
end
