Rails.application.routes.draw do
  get '/u/:user_username', to: 'commits#index', as: 'user'

  resources :users, only: [:create, :new], param: :username do
    resources :commits, only: [:index]

    member do
      get :refresh
    end
  end

  root 'commits#index'
end
