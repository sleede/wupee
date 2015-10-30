json.extract! notification, :id, :notification_type_id, :created_at, :is_read
json.attached_object notification.attached_object
json.message do
  json.partial! "wupee/api/notifications/#{notification.notification_type.name}", notification: notification
end
