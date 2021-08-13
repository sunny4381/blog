Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints(->(request) { request.env["sophon.tenant"].present? }) do
    get 'login', to: 'login#new'
    post 'login', to: 'login#create'
    match 'logout', to: 'login#logout', via: %i[get post]

    resource :dashboard, only: :show

    namespace :share do
      resources :folders, only: %i[new create]
      resources :files, only: %i[new create]
    end
    resources :shares, controller: "share/bases", except: %i[new create] do
      get :download, on: :member
      match :move, on: :member, via: %i[get post]
    end

    namespace :sys do
      resources :tenants do
        get :delete, on: :member

        resources :virtual_hosts do
          get :delete, on: :member
        end
      end

      resources :users do
        get :delete, on: :member
      end
      resources :groups do
        match :move, on: :member, via: %i[get patch]
        get :delete, on: :member
      end
    end

    get "/" => "dashboards#show"
  end
end
