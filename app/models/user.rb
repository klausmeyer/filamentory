class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :openid_connect ]

  has_many :spools, dependent: :destroy
  has_many :user_identities, dependent: :destroy

  def gravatar_hash
    Digest::MD5.hexdigest(email.downcase)
  end

  def oidc_identity
    user_identities.find { |identity| identity.provider == "openid_connect" }
  end
end
