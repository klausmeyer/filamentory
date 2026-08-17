Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "spools#index"

  resources :spools, only: [ :new, :create, :edit, :update, :destroy ]

  resources :activities, only: [ :index ]

  resources :statistics, only: [ :index ]
end
