Rails.application.config.to_prepare do
  Trestle::ApplicationController.include(PaperTrail::Rails::Controller)
  Trestle::ApplicationController.before_action(:set_paper_trail_whodunnit)
end

