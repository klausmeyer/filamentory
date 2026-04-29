require "rails_helper"

RSpec.describe "Lookup models", type: :model do
  fixtures :brands, :materials, :variants

  it "enforces unique names for Brand, Material, and Variant" do
    brands(:bambu_lab)
    materials(:pla)
    variants(:basic)

    expect(Brand.new(name: "Bambu Lab")).not_to be_valid
    expect(Material.new(name: "PLA")).not_to be_valid
    expect(Variant.new(name: "Basic")).not_to be_valid
  end
end
