Rails.application.routes.draw do
  devise_for :users,
             skip: [ :registrations ],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :users do
    resource :oidc_link, only: [ :new, :destroy ] do
      get :unlink
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "spools#index"

  resources :spools, only: [ :new, :create, :edit, :update, :destroy ]

  resources :activities, only: [ :index ]

  resources :statistics, only: [ :index ]
end
