class User < ActiveRecord::Base
  include Wupee::NotificationReceiver
end
