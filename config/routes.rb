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
      get 'bookmarked', to: 'onsens#bookmarked', as: 'bookmarked'
      get 'search'
      get 'detail_search'
      get 'search_with_details'
      get 'roten', to: 'onsens#roten'
    end
  
    member do
      post :bookmark
      delete :destroy 
    end

    resource :room, only: [:show, :create] do
      get 'messages/:id/edit', to: 'rooms#edit_message', as: 'edit_message'
      patch 'messages/:id', to: 'rooms#update_message', as: 'update_message'
      get 'thread/:parent_message_id', to: 'rooms#thread', as: 'thread'
    end
  end
end
