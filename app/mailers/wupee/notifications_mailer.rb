module Wupee
  class NotificationsMailer < ActionMailer::Base
    after_action :mark_notification_as_sent

    def send_mail_for(notification, subject_interpolations = {})
      @notification = notification
      @recipient = notification.receiver
      @attached_object = notification.attached_object
      @subject_interpolations = subject_interpolations

      if !respond_to?(notification.notification_type.name)
        class_eval %Q{
          def #{notification.notification_type.name}
            mail to: @recipient.email,
                 subject: t('wupee.email_subjects.#{notification.notification_type.name}', @subject_interpolations),
                 template_name: '#{notification.notification_type.name}',
                 content_type: 'text/html'
          end
        }
      end

      send(notification.notification_type.name)
    end

    private
      def mark_notification_as_sent
        @notification.mark_as_sent unless @notification.is_sent
      end
  end
end
