class Message < ActiveRecord::Base
  include NotifyWith::NotificationAttachedObject
end
