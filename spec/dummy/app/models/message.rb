class Message < ActiveRecord::Base
  include Wupee::NotificationAttachedObject
end
