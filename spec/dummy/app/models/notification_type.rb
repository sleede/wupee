class NotificationType
  include NotifyWith::NotificationType

  notification_type_names %w(
    notify_new_message
  )
end
