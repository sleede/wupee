class NotifyWith::NotificationTypesReceiver < ActiveRecord::Base
  self.table_name = 'notification_types_receivers'

  belongs_to :receiver, polymorphic: true
  belongs_to :notification_type, class_name: "NotifyWith::NotificationType"
end
