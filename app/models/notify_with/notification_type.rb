class NotifyWith::NotificationType < ActiveRecord::Base
  self.table_name = 'notification_types'

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_type_configurations, foreign_key: :notification_type_id, dependent: :destroy

  def self.create_configurations_for(*receivers)
    class_eval do
      receivers.each do |receiver|
        after_create do
          receiver.to_s.constantize.pluck(:id).each do |receiver_id|
            NotifyWith::NotificationTypeConfiguration.create!(notification_type: self, receiver_type: receiver, receiver_id: receiver_id)
          end
        end
      end
    end
  end
end
