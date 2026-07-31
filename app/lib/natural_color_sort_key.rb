class NaturalColorSortKey
  NEUTRAL_SATURATION_THRESHOLD = 0.12
  HUE_ROTATION = 30.0

  def self.for(color_hex:, color_name:)
    new(color_hex, color_name).to_s
  end

  def initialize(color_hex, color_name)
    @color_hex = color_hex
    @color_name = color_name
  end

  def to_s
    rgb = normalized_rgb

    return "2|#{normalized_color_name}|#{color_hex.to_s.downcase}" if rgb.nil?

    hue, saturation, lightness = hsl_from_rgb(*rgb)

    if saturation < NEUTRAL_SATURATION_THRESHOLD
      format("0|%06.4f|%s", lightness, normalized_color_name)
    else
      format("1|%08.4f|%06.4f|%06.4f|%s", rotated_hue(hue), lightness, saturation, normalized_color_name)
    end
  end

  private

  attr_reader :color_hex, :color_name

  def normalized_color_name
    color_name.to_s.downcase
  end

  def normalized_rgb
    hex = color_hex.to_s.delete_prefix("#")
    hex = hex.chars.map { |char| char * 2 }.join if hex.length == 3

    return unless hex.match?(/\A\h{6}\z/)

    hex.scan(/../).map { |component| component.to_i(16) / 255.0 }
  end

  def hsl_from_rgb(red, green, blue)
    max = [ red, green, blue ].max
    min = [ red, green, blue ].min
    lightness = (max + min) / 2.0
    delta = max - min

    return [ 0.0, 0.0, lightness ] if delta.zero?

    saturation =
      if lightness > 0.5
        delta / (2.0 - max - min)
      else
        delta / (max + min)
      end

    hue =
      case max
      when red
        ((green - blue) / delta) % 6
      when green
        ((blue - red) / delta) + 2
      else
        ((red - green) / delta) + 4
      end

    [ hue * 60.0, saturation, lightness ]
  end

  def rotated_hue(hue)
    (hue + HUE_ROTATION) % 360.0
  end
end
