Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :sys do
    resources :tenants do
      get :delete, on: :member

      resources :virtual_hosts do
        get :delete, on: :member
      end
    end

    constraints(lambda { |request| request.env["sophon.tenant"].present? }) do
      resources :users do
        get :delete, on: :member
      end
      resources :groups do
        match :move, on: :member, via: %i[get patch]
        get :delete, on: :member
      end
    end
  end
end
