Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    get 'info/:token', to: 'orders#info'
    get 'orders/:token', to: 'orders#show'
    post 'orders', to: 'orders#create'
    put 'orders/:token', to: 'orders#update'

    get 'menuitems', to: 'menuitems#index'
    get 'menuitems/:id', to: 'menuitems#show'
  end

  get '*foo', :to => 'application#index'

  root 'application#index'
end
