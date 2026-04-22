require "rails_helper"

RSpec.describe Filament, type: :model do
  def create_product!(name: "Bambu Lab - PLA Basic", spool_weight_grams: 250, weight_grams: 1_000)
    brand = Brand.create!(name: "#{name} Brand")
    material = Material.create!(name: "#{name} Material")
    variant = Variant.create!(name: "#{name} Variant")

    Product.create!(
      name: name,
      brand: brand,
      material: material,
      variant: variant,
      spool_weight_grams: spool_weight_grams,
      weight_grams: weight_grams
    )
  end

  it "computes and persists name from product + color_name" do
    product = create_product!

    filament = Filament.create!(
      product: product,
      color_name: "Black",
      color_hex: "#000000"
    )

    expect(filament.name).to eq("Bambu Lab - PLA Basic - Black")
  end

  it "updates name when color_name changes" do
    product = create_product!
    filament = Filament.create!(product: product, color_name: "Black", color_hex: "#000000")

    filament.update!(color_name: "Grey")

    expect(filament.name).to eq("Bambu Lab - PLA Basic - Grey")
  end

  it "updates name when product changes" do
    product1 = create_product!(name: "Bambu Lab - PLA Basic")
    product2 = create_product!(name: "Elegoo - PLA Basic")

    filament = Filament.create!(product: product1, color_name: "Black", color_hex: "#000000")
    filament.update!(product: product2)

    expect(filament.name).to eq("Elegoo - PLA Basic - Black")
  end
end
