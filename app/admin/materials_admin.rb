Trestle.resource(:materials) do
  menu do
    group :inventory do
      item :materials, icon: "fas fa-atom", priority: :last
    end
  end

  table do
    column :name, link: true
    column :updated_at, align: :center
    actions
  end

  form do |material|
    text_field :name
  end

  params do |params|
    params.require(:material).permit(:name)
  end
end
