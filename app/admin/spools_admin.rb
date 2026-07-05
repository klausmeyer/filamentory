Trestle.resource(:spools) do
  menu do
    group :inventory do
      item :spools, icon: "fas fa-circle-notch", priority: :first
    end
  end

  # Customize the table columns shown on the index view.
  #
  # table do
  #   column :name
  #   column :created_at, align: :center
  #   actions
  # end

  # Customize the form fields shown on the new/edit views.
  #
  # form do |spool|
  #   text_field :name
  #
  #   row do
  #     col { datetime_field :updated_at }
  #     col { datetime_field :created_at }
  #   end
  # end

  form do |spool|
    tab :details do
      row do
        col(sm: 12) do
          select :variant_id, Variant.order(:name).pluck(:name, :id), label: "Variant"
        end
      end

      row do
        number_field :remaining_weight_gross
      end

      row do
        col(sm: 6) { check_box :ovp }
        col(sm: 6) { check_box :refill }
      end
    end

    tab :history, badge: (spool.persisted? ? spool.versions.count : 0) do
      if spool.persisted?
        table spool.versions.reorder(id: :desc).limit(50) do
          column :event, align: :center
          column :whodunnit, header: "User" do |version|
            user = User.find_by(id: version.whodunnit)
            user&.email || version.whodunnit || "-"
          end
          column :created_at, header: "At", align: :center
          column :changes, header: "Changes" do |version|
            changeset = version.changeset&.except("updated_at", "created_at") || {}

            if changeset.blank?
              "-"
            else
              content_tag(:ul, class: "list-unstyled mb-0") do
                safe_join(
                  changeset.map do |attr, (from, to)|
                    content_tag(:li) do
                      safe_join(
                        [
                          content_tag(:strong, attr),
                          "#{from.inspect} → #{to.inspect}"
                        ],
                        ": "
                      )
                    end
                  end
                )
              end
            end
          end
        end
      else
        concat(content_tag(:p, "Save this spool to see its change history.", class: "text-muted"))
      end
    end
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:spool).permit(:name, ...)
  # end
end
