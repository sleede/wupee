module Wupee
  module AttachedObject
    extend ActiveSupport::Concern

    included do
      has_many :notifications_as_attached_object, as: :attached_object, dependent: :destroy, class_name: "Wupee::Notification"
    end
  end
end
