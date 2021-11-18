module Wupee
  module Receiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy, class_name: "Wupee::Notification"
      has_many :notification_type_configurations, as: :receiver, dependent: :destroy, class_name: "Wupee::NotificationTypeConfiguration"

      after_create :create_notification_type_configurations
    end

    def create_notification_type_configurations
      Wupee::NotificationType.pluck(:id).each do |notification_type_id|
        Wupee::NotificationTypeConfiguration.create!(notification_type_id: notification_type_id, receiver: self)
      end
    end
  end
end
