Trestle.resource(:users, model: User, scope: Auth) do
  menu do
    group :configuration, priority: :last do
      item :users, icon: "fas fa-users"
    end
  end

  table do
    column :avatar, header: false do |user|
      avatar_for(user)
    end
    column :email, link: true
    column :oidc, header: -> { oidc_provider_name }, align: :center do |user|
      if user.oidc_identity
        status_tag("Linked", :success)
      else
        status_tag("Not linked", :default)
      end
    end
    actions do |a|
      a.delete unless a.instance == current_user
    end
  end

  form do |user|
    text_field :email

    static_field :oidc_account, label: "#{oidc_provider_name} Account" do
      identity = user.oidc_identity

      if identity
        identity_status = [
          tag.p(identity.email.presence || identity.uid, class: "form-control-static"),
          tag.p("Linked #{l(identity.updated_at, format: :short)}", class: "form-text")
        ]
        identity_status << oidc_unlink_button if user == current_user
        safe_join(identity_status)
      elsif user == current_user
        oidc_connect_link
      else
        tag.p("Not linked", class: "form-control-static text-muted")
      end
    end

    row do
      col(sm: 6) { password_field :password }
      col(sm: 6) { password_field :password_confirmation }
    end
  end

  # Ignore the password parameters if they are blank
  update_instance do |instance, attrs|
    if attrs[:password].blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation) if attrs[:password_confirmation].blank?
    end

    instance.assign_attributes(attrs)
  end

  # Log the current user back in if their password was changed
  after_action on: :update do
    if instance == current_user && instance.encrypted_password_previously_changed?
      login!(instance)
    end
  end if Devise.sign_in_after_reset_password
end
