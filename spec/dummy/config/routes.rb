Rails.application.routes.draw do
  mount NotifyWith::Engine, at: "/notify_with"
end
