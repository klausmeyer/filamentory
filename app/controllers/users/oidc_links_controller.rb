class Users::OidcLinksController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def unlink
  end

  def destroy
    identity = current_user.oidc_identity

    if identity
      identity.destroy!
      redirect_to root_path, notice: "#{oidc_provider_name} account unlinked."
    else
      redirect_to root_path, alert: "No linked #{oidc_provider_name} account was found."
    end
  end

  private

  def oidc_provider_name
    ENV["OIDC_PROVIDER"].presence || "OIDC"
  end
end
