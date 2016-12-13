class Wupee::NotificationType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_type_configurations, foreign_key: :notification_type_id, dependent: :destroy
  has_many :notifications, foreign_key: :notification_type_id, dependent: :destroy

end
