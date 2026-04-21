class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include PaperTrail::Rails::Controller
  before_action :set_paper_trail_whodunnit

  include DeleteRestrictionHandling
end
