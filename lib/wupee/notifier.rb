module Wupee
  class Notifier
    attr_reader :deliver_when, :attached_object, :receiver_s, :notification_type, :subject_vars, :locals

    def initialize(opts = {})
      @attached_object = opts[:attached_object]

      receiver_arg = opts[:receiver] || opts[:receivers]
      receiver(receiver_arg) if receiver_arg

      @subject_vars = opts[:subject_vars] || {}
      @locals = opts[:locals] || {}

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
      @receiver_s = [*receiver]
    end

    def receivers(receivers)
      receiver(receivers)
    end

    def deliver(deliver_method)
      @deliver_when = deliver_method
    end

    def subject_vars(subject_vars = {})
      @subject_vars = subject_vars
    end

    def locals(locals = {})
      @locals = locals
    end

    def execute
      raise ArgumentError.new('receiver or receivers is missing') if @receiver_s.nil?
      raise ArgumentError.new('notif_type is missing') if @notification_type.nil?

      notif_type_configs = Wupee::NotificationTypeConfiguration.includes(:receiver).where(receiver: @receiver_s, notification_type: @notification_type)

      notif_type_configs.each do |notif_type_config|
        notification = Wupee::Notification.new(receiver: notif_type_config.receiver, notification_type: @notification_type, attached_object: @attached_object)
        notification.is_read = true unless notif_type_config.wants_notification?
        notification.save!

        subject_interpolations = interpolate_vars(@subject_vars, notification)
        locals_interpolations = interpolate_vars(@locals, notification)

        send_email(notification, subject_interpolations, locals_interpolations) if notif_type_config.wants_email?
      end
    end

    private
      def send_email(notification, subject_interpolations, locals_interpolations)
        deliver_method = "deliver_#{@deliver_when || Wupee.deliver_when}"
        Wupee.mailer.send_mail_for(notification, subject_interpolations, locals_interpolations).send(deliver_method)
      end

      def interpolate_vars(vars, notification)
        vars_interpolated = {}
        vars.each do |key, value|
          vars_interpolated[key] = if value.kind_of?(Proc)
            notification.instance_eval(&value)
          else
            value
          end
        end

        vars_interpolated
      end
  end
end
