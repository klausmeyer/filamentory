Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("/inventory")

  get "/inventory", to: "spools#index"
end
