class UserIdentity < ApplicationRecord
  belongs_to :user

  before_validation :default_email_verified

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }
  validates :uid, uniqueness: { scope: :issuer }, if: -> { issuer.present? }

  def self.attributes_from_auth(auth)
    raw_info = auth.dig("extra", "raw_info") || {}
    info = auth["info"] || {}
    email_verified = if info.key?("email_verified")
      info["email_verified"]
    elsif raw_info.key?("email_verified")
      raw_info["email_verified"]
    else
      false
    end

    {
      provider: auth["provider"],
      uid: auth["uid"],
      issuer: raw_info["iss"] || raw_info["issuer"],
      email: info["email"] || raw_info["email"],
      email_verified: ActiveModel::Type::Boolean.new.cast(email_verified) || false,
      name: info["name"] || raw_info["name"],
      raw_info: raw_info
    }
  end

  private

  def default_email_verified
    self.email_verified = false if email_verified.nil?
  end
end
