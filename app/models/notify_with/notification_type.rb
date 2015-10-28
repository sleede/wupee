class NotifyWith::NotificationType < ActiveRecord::Base
  self.table_name = 'notification_types'

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_types_receivers, foreign_key: :notification_type_id, dependent: :destroy
end
