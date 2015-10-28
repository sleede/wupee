module NotifyWith
  module NotificationReceiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy, class_name: "NotifyWith::Notification"
      has_many :notification_types_receivers, as: :receiver, dependent: :destroy, class_name: "NotifyWith::NotificationTypesReceiver"
    end
  end
end
