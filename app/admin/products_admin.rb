Trestle.resource(:products) do
  menu do
    group :inventory do
      item :products, icon: "fas fa-box", priority: :last
    end
  end

  table do
    column :name, link: true
    column :brand
    column :material
    column :variant
    column :weight_grams, header: "Weight (g)", align: :right do |product|
      grams_number(product.weight_grams)
    end
    column :spool_weight_grams, header: "Spool (g)", align: :right do |product|
      grams_number(product.spool_weight_grams)
    end
    column :updated_at, align: :center
    actions
  end

  form do |product|
    text_field :name

    row do
      col(sm: 4) { select :brand, Brand.order(:name) }
      col(sm: 4) { select :material, Material.order(:name) }
      col(sm: 4) { select :variant, Variant.order(:name) }
    end

    row do
      col(sm: 6) { number_field :weight_grams, label: "Net weight (g)" }
      col(sm: 6) { number_field :spool_weight_grams, label: "Empty spool weight (g)" }
    end
  end

  params do |params|
    params.require(:product).permit(
      :name,
      :brand_id,
      :material_id,
      :variant_id,
      :weight_grams,
      :spool_weight_grams
    )
  end
end
