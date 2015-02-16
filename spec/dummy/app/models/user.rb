class User < ActiveRecord::Base
  include NotifyWith::NotificationReceiver
end
