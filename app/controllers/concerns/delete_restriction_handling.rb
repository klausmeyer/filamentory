module DeleteRestrictionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::DeleteRestrictionError do |exception|
      message =
        if Rails.env.development?
          exception.message
        else
          "Cannot delete this record because dependent records exist."
        end

      redirect_back(
        fallback_location: root_path,
        flash: {
          error: message, # Trestle consumes flash[:error]
          alert: message  # Non-Trestle layouts often consume flash[:alert]
        }
      )
    end
  end
end

