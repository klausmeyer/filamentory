require "rails_helper"

RSpec.describe NaturalColorSortKey do
  it "sorts neutral colors before saturated colors by lightness" do
    expect(described_class.for(color_hex: "#000000", color_name: "Black")).to eq("0|0.0000|black")
    expect(described_class.for(color_hex: "#ffffff", color_name: "White")).to eq("0|1.0000|white")
  end

  it "sorts saturated colors by rotated hue" do
    expect(described_class.for(color_hex: "#ff0000", color_name: "Red")).to start_with("1|030.0000")
    expect(described_class.for(color_hex: "#ffff00", color_name: "Yellow")).to start_with("1|090.0000")
    expect(described_class.for(color_hex: "#00ff00", color_name: "Green")).to start_with("1|150.0000")
    expect(described_class.for(color_hex: "#0000ff", color_name: "Blue")).to start_with("1|270.0000")
  end

  it "keeps reds around the hue boundary together" do
    colors = [
      [ "#006eb7", "Blue" ],
      [ "#d93b3b", "Red" ],
      [ "#ae96d4", "Lavender" ],
      [ "#b2353b", "Crimson" ]
    ]

    expect(colors.sort_by { |color_hex, color_name| described_class.for(color_hex: color_hex, color_name: color_name) }.map(&:first)).to eq(
      [ "#b2353b", "#d93b3b", "#006eb7", "#ae96d4" ]
    )
  end
end
