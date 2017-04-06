Rails.application.routes.draw do
  resources :notifications, only: [:index, :show], defaults: { format: :json } do
    patch :mark_as_read, on: :member
    patch :mark_all_as_read, on: :collection
  end
end
