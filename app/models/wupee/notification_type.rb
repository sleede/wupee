class Wupee::NotificationType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notifications, foreign_key: :notification_type_id, dependent: :destroy
end
