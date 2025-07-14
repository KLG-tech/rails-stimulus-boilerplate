Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  get "home" => "home#index", as: :home
  get 'calendar' => 'calendar#index', as: :calendar


  root "home#index"

  if Rails.application.config.x.keycloak.enabled
    devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
  else
    devise_for :users
  end
  resource :sessions, only: [ :destroy ]

  mount MissionControl::Jobs::Engine, at: "/jobs"
end
