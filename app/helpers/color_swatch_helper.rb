module ColorSwatchHelper
  def color_swatch(hex_color, size: 16, title: nil)
    return tag.span("-", class: "text-muted") if hex_color.blank?

    tag.span(
      "",
      class: "color-swatch",
      title: title || hex_color,
      style: "background-color: #{hex_color}; width: #{size}px; height: #{size}px;"
    )
  end
end

