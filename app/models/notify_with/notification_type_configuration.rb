class NotifyWith::NotificationTypeConfiguration < ActiveRecord::Base
  self.table_name = 'notification_type_configurations'

  belongs_to :receiver, polymorphic: true
  belongs_to :notification_type, class_name: "NotifyWith::NotificationType"

  enum value: { both: 0, nothing: 1, email: 2, notification: 3 }
end
