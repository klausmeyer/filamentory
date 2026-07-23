class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_many :spools, dependent: :destroy

  def gravatar_hash
    Digest::MD5.hexdigest(email.downcase)
  end
end
