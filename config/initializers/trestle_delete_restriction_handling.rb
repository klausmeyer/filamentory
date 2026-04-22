Rails.application.config.to_prepare do
  Trestle::ApplicationController.include(DeleteRestrictionHandling)
end
