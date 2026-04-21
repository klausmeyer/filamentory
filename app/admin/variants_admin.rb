Trestle.resource(:variants) do
  menu do
    group :inventory do
      item :variants, icon: "fas fa-tags", priority: :last
    end
  end

  table do
    column :name, link: true
    column :updated_at, align: :center
    actions
  end

  form do |variant|
    text_field :name
  end

  params do |params|
    params.require(:variant).permit(:name)
  end
end
