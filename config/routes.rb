Wupee::Engine.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :notifications, only: [:index, :show, :update] do
      match :update_all, path: '/', via: [:put, :patch], on: :collection
    end
  end
end
