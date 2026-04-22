require "rails_helper"

RSpec.describe Product, type: :model do
  def create_product!(name: "Bambu Lab - PLA Basic", spool_weight_grams: 250, weight_grams: 1_000)
    brand = Brand.create!(name: "Bambu Lab")
    material = Material.create!(name: "PLA")
    variant = Variant.create!(name: "Basic")

    Product.create!(
      name: name,
      brand: brand,
      material: material,
      variant: variant,
      spool_weight_grams: spool_weight_grams,
      weight_grams: weight_grams
    )
  end

  it "requires a unique name" do
    create_product!(name: "Unique Name")

    duplicate =
      Product.new(
        name: "Unique Name",
        brand: Brand.create!(name: "Other Brand"),
        material: Material.create!(name: "Other Material"),
        variant: Variant.create!(name: "Other Variant"),
        spool_weight_grams: 250,
        weight_grams: 1_000
      )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to be_present
  end

  it "validates weight_grams > 0" do
    brand = Brand.create!(name: "Bambu Lab")
    material = Material.create!(name: "PLA")
    variant = Variant.create!(name: "Basic")

    product =
      Product.new(
        name: "Bad Weight",
        brand: brand,
        material: material,
        variant: variant,
        spool_weight_grams: 250,
        weight_grams: 0
      )

    expect(product).not_to be_valid
    expect(product.errors[:weight_grams]).to be_present
  end

  it "validates spool_weight_grams >= 0" do
    brand = Brand.create!(name: "Bambu Lab")
    material = Material.create!(name: "PLA")
    variant = Variant.create!(name: "Basic")

    product =
      Product.new(
        name: "Bad Spool Weight",
        brand: brand,
        material: material,
        variant: variant,
        spool_weight_grams: -1,
        weight_grams: 1_000
      )

    expect(product).not_to be_valid
    expect(product.errors[:spool_weight_grams]).to be_present
  end
end
