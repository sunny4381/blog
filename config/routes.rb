Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :sys do
    resources :tenants do
      get :delete, on: :member
    end
  end
end
