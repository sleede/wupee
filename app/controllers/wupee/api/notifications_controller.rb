module Wupee
  class Api::NotificationsController < ApplicationController
    def index
      scopes = params[:scopes].present? ? params[:scopes].split(',') : []
      scopes = ['read', 'unread', 'wanted', 'unwanted', 'ordered'] & scopes
      
      @notifications = current_user.notifications

      scopes.each do |scope|
        @notifications = @notifications.public_send(scope)
      end
    end

    def show
      @notification = find_notification
    end

    def mark_as_read
      @notification = find_notification
      @notification.mark_as_read
      render :show
    end

    def mark_all_as_read
      current_user.notifications.unread.update_all(is_read: true)
      head :no_content
    end

    private
      def find_notification
        current_user.notifications.find(params[:id])
      end
  end
end
