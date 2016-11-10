class Wupee::Notification < ActiveRecord::Base
  belongs_to :receiver, polymorphic: true
  belongs_to :actor, polymorphic: true
  belongs_to :attached_object, polymorphic: true
  belongs_to :notification_type, class_name: "Wupee::NotificationType"

  validates_presence_of :receiver,
                        :notification_type

  scope :unread, -> { where(is_read: false) }
  scope :ordered, -> { order(created_at: :desc) }

  def mark_as_read
    update_columns(is_read: true)
  end

  def mark_as_sent
    update_columns(is_sent: true)
  end
end
