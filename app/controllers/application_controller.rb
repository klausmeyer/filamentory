class ApplicationController < ActionController::Base
  include PaperTrail::Rails::Controller
  include DeleteRestrictionHandling

  allow_browser versions: :modern

  stale_when_importmap_changes

  before_action :turbo_frame_request_variant
  before_action :set_paper_trail_whodunnit

  private

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def require_authenticated_user
    head :unauthorized unless user_signed_in?
  end
end
