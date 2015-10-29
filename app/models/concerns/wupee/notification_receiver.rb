module Wupee
  module NotificationReceiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy, class_name: "Wupee::Notification"
      has_many :notification_type_configurations, as: :receiver, dependent: :destroy, class_name: "Wupee::NotificationTypeConfiguration"

      after_create do
        Wupee::NotificationType.pluck(:id).each do |notification_type_id|
          Wupee::NotificationTypeConfiguration.create!(notification_type_id: notification_type_id, receiver: self)
        end
      end
    end
  end
end
