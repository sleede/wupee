module NotifyWith
  module NotificationReceiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy
    end
  end
end
