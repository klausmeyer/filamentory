require "rails_helper"

RSpec.describe Spool, type: :model do
  around do |example|
    PaperTrail.request(enabled: true) do
      example.run
    end
  end

  def create_product!(name:, spool_weight_grams:, weight_grams: 1_000)
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

  def create_filament!(product:, color_name:, color_hex: "#000000")
    Filament.create!(product: product, color_name: color_name, color_hex: color_hex)
  end

  it "sets remaining_weight_grams to (gross - spool_weight) when gross weight is present" do
    product = create_product!(name: "P1", spool_weight_grams: 250)
    filament = create_filament!(product: product, color_name: "Black")

    spool = Spool.create!(filament: filament, gross_weight_grams: 714, ovp: false, refill_only: false)

    expect(spool.remaining_weight_grams).to eq(464)
  end

  it "clamps remaining_weight_grams at 0 when gross is below spool weight" do
    product = create_product!(name: "P1", spool_weight_grams: 250)
    filament = create_filament!(product: product, color_name: "Black")

    spool = Spool.create!(filament: filament, gross_weight_grams: 100, ovp: false, refill_only: false)

    expect(spool.remaining_weight_grams).to eq(0)
  end

  it "sets remaining_weight_grams to product weight when gross weight is nil" do
    product = create_product!(name: "P1", spool_weight_grams: 250, weight_grams: 1_000)
    filament = create_filament!(product: product, color_name: "Black")

    spool = Spool.create!(filament: filament, gross_weight_grams: nil, ovp: false, refill_only: false)

    expect(spool.remaining_weight_grams).to eq(1_000)
  end

  it "uses the updated filament_id when changing the association in one update" do
    product_a = create_product!(name: "PA", spool_weight_grams: 250, weight_grams: 1_000)
    product_b = create_product!(name: "PB", spool_weight_grams: 175, weight_grams: 750)

    filament_a = create_filament!(product: product_a, color_name: "Black")
    filament_b = create_filament!(product: product_b, color_name: "Blue")

    spool = Spool.create!(filament: filament_a, gross_weight_grams: 714, ovp: false, refill_only: false)

    # Load association, then update filament_id to ensure we don't accidentally reuse it.
    spool.filament

    spool.update!(filament_id: filament_b.id, gross_weight_grams: nil)

    expect(spool.remaining_weight_grams).to eq(750)
  end

  it "creates a PaperTrail version when updating" do
    product = create_product!(name: "P1", spool_weight_grams: 250)
    filament = create_filament!(product: product, color_name: "Black")
    spool = Spool.create!(filament: filament, gross_weight_grams: 714, ovp: false, refill_only: false, comment: nil)

    expect { spool.update!(comment: "Updated") }.to change { spool.versions.count }.by(1)

    update_version = spool.versions.where(event: "update").order(id: :desc).first
    expect(update_version).to be_present
    expect(update_version.changeset.fetch("comment")).to eq([ nil, "Updated" ])
  end

  it "sorts spools by product, natural color order, and remaining weight" do
    product_a = create_product!(name: "A", spool_weight_grams: 250)
    product_b = create_product!(name: "B", spool_weight_grams: 250)

    red = create_filament!(product: product_a, color_name: "Red", color_hex: "#ff0000")
    blue = create_filament!(product: product_a, color_name: "Blue", color_hex: "#0000ff")
    yellow = create_filament!(product: product_a, color_name: "Yellow", color_hex: "#ffff00")
    white = create_filament!(product: product_a, color_name: "White", color_hex: "#ffffff")
    black = create_filament!(product: product_a, color_name: "Black", color_hex: "#000000")
    green = create_filament!(product: product_a, color_name: "Green", color_hex: "#00ff00")
    other_product_red = create_filament!(product: product_b, color_name: "Red", color_hex: "#ff0000")

    Spool.create!(filament: blue, gross_weight_grams: nil, ovp: false, refill_only: false)
    Spool.create!(filament: green, gross_weight_grams: nil, ovp: false, refill_only: false)
    Spool.create!(filament: black, gross_weight_grams: nil, ovp: false, refill_only: false)
    Spool.create!(filament: other_product_red, gross_weight_grams: nil, ovp: false, refill_only: false)
    Spool.create!(filament: red, gross_weight_grams: 750, ovp: false, refill_only: false)
    Spool.create!(filament: white, gross_weight_grams: nil, ovp: false, refill_only: false)
    Spool.create!(filament: yellow, gross_weight_grams: nil, ovp: false, refill_only: false)
    Spool.create!(filament: red, gross_weight_grams: 600, ovp: false, refill_only: false)

    sorted = Spool.sorted_by_filament.select { |spool| [ product_a, product_b ].include?(spool.filament.product) }

    expect(sorted.map { |spool| [ spool.filament.product.name, spool.filament.color_name, spool.remaining_weight_grams ] }).to eq(
      [
        [ "A", "Black", 1_000 ],
        [ "A", "White", 1_000 ],
        [ "A", "Red", 350 ],
        [ "A", "Red", 500 ],
        [ "A", "Yellow", 1_000 ],
        [ "A", "Green", 1_000 ],
        [ "A", "Blue", 1_000 ],
        [ "B", "Red", 1_000 ]
      ]
    )
  end
end
