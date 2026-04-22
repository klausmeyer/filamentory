require "rails_helper"

RSpec.describe User, type: :model do
  it "requires an email" do
    user = User.new(password: "password123", password_confirmation: "password123")

    expect(user).not_to be_valid
    expect(user.errors[:email]).to be_present
  end

  it "requires a password" do
    user = User.new(email: "test@example.com")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to be_present
  end
end
