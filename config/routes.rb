# config/routes.rb

Rails.application.routes.draw do
  resources :screenshots, only: [:index] do
    post :capture, on: :collection
    get :success, on: :collection
  end

  root to: 'screenshots#index'
end
