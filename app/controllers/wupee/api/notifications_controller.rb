module Wupee
  class Api::NotificationsController < ApplicationController
    respond_to :json
    before_action :set_notification, only: [:show, :update]

    def current_user
    end

    def index
      if params[:is_read]
        @notifications = current_user.notifications.where(is_read: params[:is_read] == "true")
      else
        @notifications = current_user.notifications
      end
    end

    def show
    end

    def update
      @notification.mark_as_read
      render :show
    end

    def update_all
      current_user.notifications.where(is_read: false).find_each do |n|
        n.mark_as_read
      end
      head :no_content
    end

    private
    def set_notification
      @notification = current_user.notifications.find(params[:id])
    end
  end
end
