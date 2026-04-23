Trestle.resource(:spools) do
  menu do
    group :inventory, priority: :first do
      item :spools, icon: "fas fa-circle-notch", priority: :first
    end
  end

  table do
    column :id, align: :right
    column :color, header: false, align: :center do |spool|
      color_swatch(spool.filament&.color_hex, size: 14)
    end
    column :name, link: true, truncate: false
    column :ovp, align: :center
    column :refill_only, align: :center
    column :gross_weight_grams, header: "Gross (g)", align: :right do |spool|
      grams_number(spool.gross_weight_grams)
    end
    column :remaining_weight_grams, header: "Net weight" do |spool|
      spool_remaining_progress_bar(spool)
    end
    column :updated_at, align: :center
    actions
  end

  form do |spool|
    tab :details do
      row do
        col(sm: 12) do
          select :filament_id, Filament.order(:name).pluck(:name, :id), label: "Filament"
        end
      end

      number_field :gross_weight_grams, label: "Gross weight (g)"

      static_field :remaining_weight_grams, label: "Net weight" do
        spool_remaining_progress_bar(spool)
      end

      text_field :comment

      row do
        col(sm: 6) { check_box :ovp, label: "OVP?" }
        col(sm: 6) { check_box :refill_only, label: "Refill only?" }
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

  collection do |params|
    Spool.includes(filament: :product)
  end

  sort_column :name do |collection, order|
    direction = order == :desc ? :desc : :asc
    collection.left_joins(:filament).reorder(Filament.arel_table[:name].public_send(direction))
  end

  params do |params|
    params.require(:spool).permit(:filament_id, :ovp, :refill_only, :gross_weight_grams, :comment)
  end
end
