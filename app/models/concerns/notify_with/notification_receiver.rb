module NotifyWith
  module NotificationReceiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy, class_name: "NotifyWith::Notification"
    end
  end
end
