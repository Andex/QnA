require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, only: %i[create destroy], shallow: true
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], except: :index, shallow: true do
      member do
        patch :best
      end
    end
    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: %i[index destroy]

  root to: "questions#index"

  get '/email', to: 'users#email'
  post '/set_email', to: 'users#set_email'

  get '/search', to: 'search#search'

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
        resources :users, only: :index do
            get :me, on: :collection
        end

        resources :questions, only: %i[index show create update destroy] do
          resources :answers, only: %i[index show create update destroy], shallow: true
        end
    end
  end
end
