class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    auth = request.env["omniauth.auth"]
    unless auth
      redirect_to new_user_session_path, alert: "#{oidc_provider_name} sign in failed."
      return
    end

    identity_attrs = UserIdentity.attributes_from_auth(auth)
    identity = UserIdentity.find_by(provider: identity_attrs[:provider], uid: identity_attrs[:uid])

    if user_signed_in?
      link_identity(identity, identity_attrs)
    elsif identity
      sign_in_identity_user(identity)
    else
      sign_in_verified_email_match(identity_attrs)
    end
  end

  def failure
    redirect_to root_path, alert: "#{oidc_provider_name} sign in failed."
  end

  private

  def oidc_provider_name
    ENV["OIDC_PROVIDER"].presence || "OIDC"
  end

  def link_identity(identity, identity_attrs)
    if identity && identity.user != current_user
      redirect_to root_path, alert: "That #{oidc_provider_name} account is already linked to another user."
      return
    end

    identity ||= current_user.user_identities.build
    identity.update!(identity_attrs)

    redirect_to root_path, notice: "#{oidc_provider_name} account linked."
  end

  def sign_in_identity_user(identity)
    sign_in_and_redirect identity.user, event: :authentication
    set_flash_message(:notice, :success, kind: oidc_provider_name) if is_navigational_format?
  end

  def sign_in_verified_email_match(identity_attrs)
    unless identity_attrs[:email_verified]
      redirect_to new_user_session_path, alert: "No linked #{oidc_provider_name} account was found."
      return
    end

    user = User.find_by(email: identity_attrs[:email].to_s.downcase)

    if user
      user.user_identities.create!(identity_attrs)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: oidc_provider_name) if is_navigational_format?
    else
      redirect_to new_user_session_path, alert: "No user exists for that #{oidc_provider_name} account."
    end
  end
end
