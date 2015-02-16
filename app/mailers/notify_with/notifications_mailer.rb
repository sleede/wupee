module NotifyWith
  class NotificationsMailer < ActionMailer::Base
    after_action :mark_notification_as_send

    def send_mail_by(notification)
      @notification = notification
      @recipient = notification.receiver
      @attached_object = notification.attached_object

      if !respond_to?(notification.notification_type)
        class_eval %Q{
          def #{notification.notification_type}
            mail to: @recipient.email,
                 subject: t('.subject_#{notification.notification_type}'),
                 template_name: '#{notification.notification_type}',
                 content_type: 'text/html'
          end
        }
      end

      send(notification.notification_type)
    end

    private
    def mark_notification_as_send
      @notification.mark_as_send unless @notification.is_send
    end
  end
end
