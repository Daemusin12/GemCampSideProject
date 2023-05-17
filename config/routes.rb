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
    get 'shop', to: 'shop#index'
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    namespace :users do
      resources :home
      resources :invite
    end
    resources :users do
      resources :user_addresses
      resources :order_history
      resources :lottery_history
      resources :winning_history
      resources :invitation_history
    end
    resources :lotteries
    resources :shop do
      get :buy
    end
  end

  constraints(AdminDomainConstraint.new) do
    get '/', to: 'admin/home#index'
    get 'bet', to: 'bet#index'
    get 'winner', to: 'winner#index'
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
    resources :offers
    resources :orders do
      post :pay
      post :cancel
    end
  end

end
