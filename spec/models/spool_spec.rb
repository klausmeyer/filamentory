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
    expect(spool.name).to eq(filament_b.name)
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
end
