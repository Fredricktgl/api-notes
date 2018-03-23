Rails.application.routes.draw do

  root "notes#index"

  resources :notes do
    post 'sync', on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
