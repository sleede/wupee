class Wupee::NotificationTypeConfiguration < ActiveRecord::Base
  belongs_to :receiver, polymorphic: true
  belongs_to :notification_type, class_name: "Wupee::NotificationType"

  validates :notification_type, uniqueness: { scope: [:receiver] }, unless: :skip_uniqueness_validation?
  
  enum config_value: { both: 0, nothing: 1, email: 2, notification: 3 }

  def wants_email?
    ['both', 'email'].include?(config_value)
  end

  def wants_notification?
    ['both', 'notification'].include?(config_value)
  end

  protected
    def skip_uniqueness_validation?
      false
    end
end
