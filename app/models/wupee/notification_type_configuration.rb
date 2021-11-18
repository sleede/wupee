class Wupee::NotificationTypeConfiguration < ActiveRecord::Base
  belongs_to :receiver, polymorphic: true
  belongs_to :notification_type, class_name: "Wupee::NotificationType"

  validates :notification_type, uniqueness: { scope: [:receiver] }, unless: :skip_uniqueness_validation?
  validates :receiver, :notification_type, presence: true

  enum value: { both: 0, nothing: 1, email: 2, notification: 3 }

  def wants_email?
    ['both', 'email'].include?(value)
  end

  def wants_notification?
    ['both', 'notification'].include?(value)
  end

  protected
    def skip_uniqueness_validation?
      false
    end
end
