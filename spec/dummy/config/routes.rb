Rails.application.routes.draw do

  #mount NotifyWith::Engine => "/notify_with"

  namespace :api, defaults: { format: :json } do
    resources :notifications, only: [:index, :show, :update] do
      match :update_all, path: '/', via: [:put, :patch], on: :collection
    end
  end
end
