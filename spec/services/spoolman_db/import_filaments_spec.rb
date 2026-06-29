require "rails_helper"

RSpec.describe SpoolmanDb::ImportFilaments do
  let(:url) { "https://github.com/Donkie/SpoolmanDB/blob/main/filaments/acme.json" }
  let(:payload) do
    {
      manufacturer: "Acme Filaments",
      filaments: [
        {
          name: "{color_name}",
          material: "ACME-PLA",
          weights: [
            { weight: 1000, spool_weight: 210 }
          ],
          diameters: [ 1.75 ],
          colors: [
            { name: "Black", hex: "000000" },
            { name: "Blue Red", hexes: [ "0000FF", "FF0000" ] }
          ]
        },
        {
          name: "Velvet {color_name}",
          material: "ACME-PLA",
          finish: "matte",
          weights: [
            { weight: 1000, spool_weight: 215 },
            { weight: 500, spool_weight: 150 }
          ],
          diameters: [ 1.75, 2.85 ],
          colors: [
            { name: "White", hex: "#FFFFFF" }
          ]
        }
      ]
    }.to_json
  end
  let(:fetcher) { instance_double(Proc) }

  before do
    allow(fetcher).to receive(:call).and_return(payload)
  end

  it "imports brands, materials, variants, products and filaments from a source JSON URL" do
    result = described_class.new(url: url, http_fetcher: fetcher).call

    expect(fetcher).to have_received(:call).with("https://raw.githubusercontent.com/Donkie/SpoolmanDB/main/filaments/acme.json")
    expect(result.brands_created).to eq(1)
    expect(result.materials_created).to eq(1)
    expect(result.variants_created).to be_between(1, 2).inclusive
    expect(result.products_created).to eq(5)
    expect(result.filaments_created).to eq(6)

    basic_product = Product.find_by!(name: "Acme Filaments - ACME-PLA Basic")
    expect(basic_product.diameter).to eq(1.75)
    expect(basic_product.weight_grams).to eq(1_000)
    expect(basic_product.spool_weight_grams).to eq(210)

    matte_product = Product.find_by!(name: "Acme Filaments - ACME-PLA Velvet 1.75mm 1000g")
    wide_matte_product = Product.find_by!(name: "Acme Filaments - ACME-PLA Velvet 2.85mm 1000g")
    expect(matte_product.variant.name).to eq("Velvet")
    expect(matte_product.diameter).to eq(1.75)
    expect(wide_matte_product.diameter).to eq(2.85)

    expect(Filament.find_by!(product: basic_product, color_name: "Black").color_hex).to eq("#000000")
    expect(Filament.find_by!(product: basic_product, color_name: "Blue Red").color_hex).to eq("#0000FF")
  end

  it "updates existing products and filaments without creating duplicates" do
    described_class.new(url: url, http_fetcher: fetcher).call

    updated_payload = JSON.parse(payload)
    updated_payload["filaments"].first["weights"].first["spool_weight"] = 220
    updated_payload["filaments"].first["colors"].first["hex"] = "111111"
    allow(fetcher).to receive(:call).and_return(updated_payload.to_json)

    result = described_class.new(url: url, http_fetcher: fetcher).call

    expect(result.products_created).to eq(0)
    expect(result.products_updated).to eq(1)
    expect(result.filaments_created).to eq(0)
    expect(result.filaments_updated).to eq(1)
    basic_product = Product.find_by!(name: "Acme Filaments - ACME-PLA Basic")

    expect(basic_product.spool_weight_grams).to eq(220)
    expect(Filament.find_by!(product: basic_product, color_name: "Black").color_hex).to eq("#111111")
  end
end
