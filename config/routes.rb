Rails.application.routes.draw do
  root 'home#top'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  devise_scope :user do
    get 'guest_login', to: 'users/sessions#guest_login'
  end

  get 'home/index', to: 'home#index'

  resources :users

  resources :onsens do
    collection do
      get 'region/:region', to: 'onsens#region', as: 'region'
      get 'region/:region/prefecture/:prefecture', to: 'onsens#prefecture', as: 'prefecture'
    end
  end
end
