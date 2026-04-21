Trestle.resource(:filaments) do
  menu do
    group :inventory, priority: :first do
      item :filaments, icon: "fas fa-palette", priority: :last
    end
  end

  table do
    column :color, header: false, align: :center do |filament|
      color_swatch(filament.color_hex, size: 14)
    end
    column :name, link: true, truncate: false
    column :product
    column :color_name
    column :color_hex do |filament|
      content_tag(:span, filament.color_hex.to_s.upcase, class: "hex-color")
    end
    column :updated_at, align: :center
    actions
  end

  form do |filament|
    row do
      col(sm: 12) { select :product, Product.order(:name) }
    end

    row do
      col(sm: 6) { text_field :color_name }
      col(sm: 6) { text_field :color_hex }
    end

    row do
      col(sm: 6) do
        static_field :preview, label: "Preview" do
          color_swatch(filament.color_hex, size: 24)
        end
      end

      col(sm: 6) do
        static_field :name, label: "Computed name" do
          filament.computed_name || "-"
        end
      end
    end
  end

  params do |params|
    params.require(:filament).permit(:product_id, :color_name, :color_hex)
  end
end
