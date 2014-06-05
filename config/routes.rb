require 'api_constraints'

Task::Application.routes.draw do
  
  #resources :clients, except: [:new, :edit]
  #resources :tokens, except: [:new, :edit]
  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
    #get 'events/show_all', to: 'events#show_all'
    devise_for :users
    namespace :appdata do
        get 'events', to: 'events#index'
        post 'events/new', to: 'events#create'
        get 'events/:id', to: 'events#show'
        post 'events/:id/edit', to: 'events#update'
        get 'events/:id/delete', to: 'events#destroy'
        get 'events/:id/reminders', to: 'events#show_reminders'
        get 'events/recent', to: 'events#show_recent'
        get 'events/upcoming', to: 'events#show_upcoming'
    end
  end 
  root to: 'events#index'
end