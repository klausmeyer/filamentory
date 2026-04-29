require "rails_helper"

RSpec.describe Product, type: :model do
  fixtures :brands, :materials, :variants, :products

  let(:bambu_lab) { brands(:bambu_lab) }
  let(:pla) { materials(:pla) }
  let(:basic) { variants(:basic) }

  it "requires a unique name" do
    products(:unique_name_product)

    duplicate =
      Product.new(
        name: "Unique Name",
        brand: brands(:other_brand),
        material: materials(:other_material),
        variant: variants(:other_variant),
        spool_weight_grams: 250,
        weight_grams: 1_000
      )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to be_present
  end

  it "validates weight_grams > 0" do
    product =
      Product.new(
        name: "Bad Weight",
        brand: bambu_lab,
        material: pla,
        variant: basic,
        spool_weight_grams: 250,
        weight_grams: 0
      )

    expect(product).not_to be_valid
    expect(product.errors[:weight_grams]).to be_present
  end

  it "validates spool_weight_grams >= 0" do
    product =
      Product.new(
        name: "Bad Spool Weight",
        brand: bambu_lab,
        material: pla,
        variant: basic,
        spool_weight_grams: -1,
        weight_grams: 1_000
      )

    expect(product).not_to be_valid
    expect(product.errors[:spool_weight_grams]).to be_present
  end
end
