Wupee.mailer = NotificationsMailer
Wupee.deliver_when = :now

Wupee::NotificationType.class_eval do
  create_configurations_for 'User'
end
