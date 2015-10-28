class NotifyWith::Notification < ActiveRecord::Base
  self.table_name = 'notifications'

  belongs_to :receiver, polymorphic: true
  belongs_to :attached_object, polymorphic: true
  belongs_to :notification_type, class_name: "NotifyWith::NotificationType"

  validates_presence_of :receiver,
                        :notification_type

  def send_notification(type: nil, attached_object: nil)
    self.notification_type = NotifyWith::NotificationType.find_by!(name: type)
    self.attached_object = attached_object
    self
  end

  def to(receiver)
    self.receiver = receiver
    self
  end

  def mark_as_read
    update_columns(is_read: true)
  end

  def mark_as_sent
    update_columns(is_sent: true)
  end

  def deliver_now
    NotifyWith.mailer.send_mail_by(self).deliver_now if save
  end

  def deliver_later
    NotifyWith.mailer.send_mail_by(self).deliver_later if save
  end
end
