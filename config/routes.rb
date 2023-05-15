Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end

  constraints(ClientDomainConstraint.new) do
    get '/', to: 'users/home#index'
    get 'lotteries', to: 'lotteries#index'
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    namespace :users do
      resources :home
      resources :invite
    end
    resources :users do
      resources :user_addresses
    end
    resources :lotteries
  end

  constraints(AdminDomainConstraint.new) do
    get '/', to: 'admin/home#index'
    get 'bet', to: 'bet#index'
    devise_for :users, as: 'admin', controllers: { sessions: 'admin/sessions', registrations: 'admin/registrations' }
    namespace :admin do
      resources :home
    end
    resources :items do
      post :start
      post :pause
      post :end
      post :cancel
    end
    resources :admin
    resources :categories, except: :show
    resources :bet do
      post :cancel
    end
  end

end
