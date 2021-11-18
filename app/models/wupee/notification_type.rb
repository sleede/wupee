class Wupee::NotificationType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_type_configurations, foreign_key: :notification_type_id, dependent: :destroy
  has_many :notifications, foreign_key: :notification_type_id, dependent: :destroy

  def self.create_configurations_for(*receivers)
    receivers.each do |receiver|
      class_eval %Q{
        method_name = "create_configurations_for_#{receiver.to_s.underscore.pluralize}"
        after_create method_name

        define_method method_name do
          receiver.to_s.constantize.pluck(:id).each do |receiver_id|
            Wupee::NotificationTypeConfiguration.create!(notification_type: self, receiver_type: receiver, receiver_id: receiver_id)
          end
        end
      }
    end
  end
end
