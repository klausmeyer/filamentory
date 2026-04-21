Trestle.resource(:brands) do
  menu do
    group :inventory do
      item :brands, icon: "fas fa-industry", priority: :last
    end
  end

  table do
    column :name, link: true
    column :updated_at, align: :center
    actions
  end

  form do |brand|
    text_field :name
  end

  params do |params|
    params.require(:brand).permit(:name)
  end
end
