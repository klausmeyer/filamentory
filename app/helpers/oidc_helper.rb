module OidcHelper
  def oidc_configured?
    Devise.omniauth_configs.key?(:openid_connect)
  end

  def oidc_authorize_path
    main_app.user_openid_connect_omniauth_authorize_path
  end

  def new_oidc_link_path
    main_app.new_users_oidc_link_path
  end

  def oidc_link_path
    main_app.users_oidc_link_path
  end

  def unlink_oidc_link_path
    main_app.unlink_users_oidc_link_path
  end

  def oidc_provider_name
    ENV["OIDC_PROVIDER"].presence || "OIDC"
  end

  def oidc_not_configured_label
    "#{oidc_provider_name} not configured"
  end

  def oidc_button(label: nil, enabled_class: "btn btn-outline-primary", disabled_class: "btn btn-outline-secondary")
    if oidc_configured?
      button_to label || "Sign in with #{oidc_provider_name}",
                oidc_authorize_path,
                method: :post,
                class: enabled_class,
                form: { data: { turbo: false } }
    else
      button_tag oidc_not_configured_label, type: :button, class: disabled_class, disabled: true
    end
  end

  def oidc_connect_link(label: nil, enabled_class: "btn btn-outline-primary", disabled_class: "btn btn-outline-secondary")
    if oidc_configured?
      link_to label || "Connect #{oidc_provider_name}", new_oidc_link_path, class: enabled_class, data: { turbo_frame: "_top" }
    else
      button_tag oidc_not_configured_label, type: :button, class: disabled_class, disabled: true
    end
  end

  def oidc_unlink_button(label: nil, enabled_class: "btn btn-outline-danger")
    link_to label || "Unlink #{oidc_provider_name}",
            unlink_oidc_link_path,
            class: enabled_class,
            data: { turbo_frame: "_top" }
  end

  def oidc_identity_status(user)
    identity = user.oidc_identity

    if identity
      identity.email.presence || identity.uid
    else
      "Not linked"
    end
  end
end
