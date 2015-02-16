class API::NotificationsController < ApplicationController
  include NotifyWith::NotificationsApi

  def current_user
  end
end
