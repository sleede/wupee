module Wupee
  class Notifier
    attr_reader :deliver_when, :attached_object, :receiver_s, :notification_type, :subject_vars

    def initialize(opts = {})
      @attached_object = opts[:attached_object]
      @receiver_s = opts[:receiver] || opts[:receivers] || []
      @subject_vars = opts[:subject_vars] || {}
      @deliver_when = opts[:deliver]
      notif_type(opts[:notif_type]) if opts[:notif_type]
    end

    def notif_type(notif_type)
      if notif_type.is_a?(Wupee::NotificationType)
        @notification_type = notif_type
      else
        @notification_type = Wupee::NotificationType.find_by!(name: notif_type)
      end
    end

    def attached_object(attached_object)
      @attached_object = attached_object
    end

    def receiver(receiver)
      @receiver_s = receiver
    end

    def receivers(receivers)
      @receiver_s = receivers
    end

    def deliver(deliver_method)
      @deliver_when = deliver_method
    end

    def subject_vars(subject_vars = {})
      @subject_vars = subject_vars
    end

    def execute
      notif_type_configs = Wupee::NotificationTypeConfiguration.includes(:receiver).where(receiver: @receiver_s, notification_type: @notification_type)

      notif_type_configs.each do |notif_type_config|
        notification = Wupee::Notification.new(receiver: notif_type_config.receiver, notification_type: @notification_type)
        notification.is_read = true unless notif_type_config.wants_notification?
        notification.save!

        subject_interpolations = interpolate_subject_vars(notification)
        send_email(notification, subject_interpolations) if notif_type_config.wants_notification?
      end
    end

    private
      def send_email(notification, subject_interpolations)
        deliver_method = "deliver_#{@deliver_when || Wupee.deliver_when}"
        Wupee.mailer.send_mail_for(notification, subject_interpolations).send(deliver_method)
      end

      def interpolate_subject_vars(notification)
        subject_vars_interpolated = {}
        @subject_vars.each do |key, value|
          subject_vars_interpolated[key] = if value.is_a?(Proc)
            notification.instance_eval(value)
          else
            value.to_s
          end
        end
      end
  end
end
