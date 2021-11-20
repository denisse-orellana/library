Rails.application.routes.draw do
  get 'users/show'
  root 'books#index'
  devise_for :users
  resources :books
  patch '/books/:id/reserve', to: 'books#reserve', as: 'reserve'
  patch '/books/:id/cancel_reserve', to: 'books#cancel_reserve', as: 'cancel_reserve'
  patch '/books/:id/purchase', to: 'books#purchase', as: 'purchase'
  patch '/books/:id/cancel_purchase', to: 'books#cancel_purchase', as: 'cancel_purchase'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end