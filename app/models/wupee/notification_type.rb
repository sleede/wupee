class Wupee::NotificationType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_type_configurations, foreign_key: :notification_type_id, dependent: :destroy
  has_many :notifications, foreign_key: :notification_type_id, dependent: :destroy

  LASA_PROJECT_ID = 132

  def self.create_configurations_for(*receivers)
    class_eval do
      receivers.each do |receiver_type|
        after_create do
          receiver_type.to_s.constantize.find_each do |receiver|
            Wupee::NotificationTypeConfiguration.create!(
              notification_type: self, 
              receiver: receiver,
              value: (receiver.project_id == LASA_PROJECT_ID) ? 1 : 0
            )
          end
        end
      end
    end
  end
end