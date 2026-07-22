ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag =~ /<(input|textarea|select)/
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.add_class("is-invalid")

    content_tag :div, class: "input-group has-validation" do
      concat html_field.to_html.html_safe
      concat content_tag :div, instance.error_message.first, class: "invalid-feedback"
    end
  else
    html_tag
  end
end
