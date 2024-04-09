# config/routes.rb

Rails.application.routes.draw do
  root 'pages#index'  # Esta línea establece la ruta raíz para que apunte a PagesController#index
  namespace :api do
    namespace :v1 do
      resources :features do
        resources :comments, only: [:create]
      end
    end
  end
end
