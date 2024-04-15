Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api, defaults: {format: 'json'} do
    resources :features do
      resources :comments, only: [:create]
    end
  end
end
