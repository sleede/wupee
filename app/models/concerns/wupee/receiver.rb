module Wupee
  module Receiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy, class_name: "Wupee::Notification"
    end
  end
end
