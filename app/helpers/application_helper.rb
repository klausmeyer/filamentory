module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type.to_s
    when "success"
      "alert-success"
    when "error"
      "alert-danger"
    when "alert"
      "alert-warning"
    when "notice"
      "alert-info"
    else
      flash_type.to_s
    end
  end

  def gramms_as_kilogram(value)
    number_with_delimiter "#{(value / 1000.0).round(2)} kg"
  end
end
