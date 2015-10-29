module Wupee
  class Notifier
    attr_accessor :notification
    attr_reader :deliver_when

    def initialize
      @notification = Wupee::Notification.new
      @deliver_when = :now
    end

    def notif_type(notif_type)
      if notif_type.is_a?(Wupee::NotificationType)
        @notification.notification_type = notif_type
      else
        @notification.notification_type = Wupee::NotificationType.find_by!(name: notif_type)
      end
    end

    def attached_object(attached_object)
      @notification.attached_object = attached_object
    end

    def receiver(receiver)
      @notification.receiver = receiver
    end

    def deliver(deliver_method)
      @deliver_when = deliver_method
    end

    def send
      notif_type_config = Wupee::NotificationTypeConfiguration.find_by!(receiver: @notification.receiver, notification_type: @notification.notification_type)

      @notification.is_read = true if ['nothing', 'email'].include?(notif_type_config.value)
      @notification.save!

      mailer_result = Wupee.mailer.send_mail_for(@notification).send("deliver_#{@deliver_when}") if ['both', 'email'].include?(notif_type_config.value)

      return @notification, mailer_result
    end
  end
end
