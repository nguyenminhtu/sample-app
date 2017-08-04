Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#index"
    get "/pages/:page", to: "static_pages#show", as: "show"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, except: [:new, :create] do
      member do
        get :following, :followers, to: "relationships#index"
      end
    end
    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
  end
  resources :account_activations, only: :edit
  resources :password_resets, except: [:index, :show, :destroy]
end
