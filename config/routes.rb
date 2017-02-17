Wupee::Engine.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :notifications, only: [:index, :show] do
      patch :mark_as_read, on: :member
      patch :mark_all_as_read, on: :collection
    end
  end
end
