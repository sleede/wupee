Wupee.mailer = NotificationsMailer
Wupee.deliver_when = :now

Wupee.email_sending_rule = Proc.new do |receiver, notification_type| 
  true
end

Wupee.notification_sending_rule = Proc.new do |receiver, notification_type| 
  true
end