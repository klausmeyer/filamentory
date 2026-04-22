require "rails_helper"

RSpec.describe "Lookup models", type: :model do
  it "enforces unique names for Brand, Material, and Variant" do
    Brand.create!(name: "Bambu Lab")
    Material.create!(name: "PLA")
    Variant.create!(name: "Basic")

    expect(Brand.new(name: "Bambu Lab")).not_to be_valid
    expect(Material.new(name: "PLA")).not_to be_valid
    expect(Variant.new(name: "Basic")).not_to be_valid
  end
end
