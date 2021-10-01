Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, except: :index, shallow: true do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: %i[index destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
