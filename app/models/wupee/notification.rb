class Wupee::Notification < ActiveRecord::Base
  belongs_to :receiver, polymorphic: true
  belongs_to :attached_object, polymorphic: true
  belongs_to :notification_type, class_name: "Wupee::NotificationType"

  validates :receiver, presence: true
  validates :notification_type, presence: true

  scope :read, -> { where(is_read: true) }
  scope :unread, -> { where(is_read: false) }
  scope :wanted, -> { where(is_wanted: true) }
  scope :unwanted, -> { where(is_wanted: false) }
  scope :ordered, -> { order(created_at: :desc) }

  def mark_as_read
    update_columns(is_read: true)
  end

  def mark_as_sent
    update_columns(is_sent: true)
  end
end
