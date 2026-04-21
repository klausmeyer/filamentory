module AdminFormatHelper
  def grams_number(value)
    return "-" if value.nil?

    number_with_delimiter(value)
  end

  def spool_remaining_percent(spool)
    total_grams = spool&.filament&.product&.weight_grams
    remaining_grams = spool&.remaining_weight_grams

    return nil if total_grams.blank? || remaining_grams.blank?

    total_grams = total_grams.to_i
    remaining_grams = remaining_grams.to_i
    return nil if total_grams <= 0

    ((remaining_grams.to_f / total_grams) * 100).floor.clamp(0, 100)
  end

  def spool_remaining_progress_bar(spool)
    total_grams = spool&.filament&.product&.weight_grams
    remaining_grams = spool&.remaining_weight_grams
    percent = spool_remaining_percent(spool)

    return "-" if percent.nil?

    meta =
      content_tag(:div, class: "spool-progress__meta") do
        safe_join(
          [
            content_tag(:span, "#{grams_number(remaining_grams)} / #{grams_number(total_grams)} g"),
            content_tag(:span, "#{percent}%", class: "spool-progress__percent")
          ],
          " "
        )
      end

    track =
      content_tag(:div, class: "spool-progress__track") do
        content_tag(:div, "", class: "spool-progress__fill", style: "width: #{percent}%;")
      end

    content_tag(:div, safe_join([meta, track]), class: "spool-progress")
  end
end
