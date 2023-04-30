Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  namespace :users do
    resources :home
  end

  devise_for :users, as: 'admin', controllers: { sessions: 'admin/sessions', registrations: 'admin/registrations' }
  namespace :admin do
    resources :home
  end
end
