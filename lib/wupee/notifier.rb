module Wupee
  class Notifier
    attr_reader :deliver_when, :attached_object, :receiver_s, :notification_type, :subject_vars, :locals, :headers, :config_scope

    def initialize(opts = {})
      @attached_object = opts[:attached_object]

      receiver_arg = opts[:receiver] || opts[:receivers]
      receiver(receiver_arg) if receiver_arg

      @subject_vars = opts[:subject_vars] || {}
      @locals = opts[:locals] || {}

      @headers = opts[:headers] || {}

      @config_scope = opts[:config_scope]

      @deliver_when = opts[:deliver]
      notif_type(opts[:notif_type]) if opts[:notif_type]
    end

    def headers(headers = {})
      @headers = headers
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

      notifications = []
      @receiver_s.each do |receiver|
        notification = Wupee::Notification.new(receiver: receiver, notification_type: @notification_type, attached_object: @attached_object)
        
        notification.is_wanted = false unless send_notification?(receiver, @notification_type)

        notification.save!

        notifications << notification

        subject_interpolations = interpolate_vars(@subject_vars, notification)
        locals_interpolations = interpolate_vars(@locals, notification)

        send_email(notification, subject_interpolations, locals_interpolations) if send_email?(receiver, @notification_type)
      end

      notifications
    end

    private
      def send_email(notification, subject_interpolations, locals_interpolations)
        deliver_method = "deliver_#{@deliver_when || Wupee.deliver_when}"
        Wupee.mailer.send_mail_for(notification, subject_interpolations, locals_interpolations, @headers).send(deliver_method)
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

      def send_notification?(receiver, notification_type)
        if !Wupee.notification_sending_rule.nil?
          if Wupee.notification_sending_rule.is_a?(Proc)  
            Wupee.notification_sending_rule.call(receiver, notification_type)
          else
            Wupee.notification_sending_rule
          end
        else
          true
        end
      end

      def send_email?(receiver, notification_type)
        if !Wupee.email_sending_rule.nil?
          if Wupee.email_sending_rule.is_a?(Proc)  
            Wupee.email_sending_rule.call(receiver, notification_type)
          else
            Wupee.email_sending_rule
          end
        else
          true
        end
      end
  end
end
