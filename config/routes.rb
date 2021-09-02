Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, except: :index, shallow: true do
      member do
        patch :best
      end
    end
  end

  root to: "questions#index"
end
