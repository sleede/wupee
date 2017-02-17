Wupee.mailer = NotificationsMailer
Wupee.deliver_when = :now

# uncomment and implement your logic here to avoid/permit email sending to your users
# leave it commented if you always want your users received emails
# Wupee.email_sending_rule = Proc.new do |receiver, notification_type| 
#   # logic goes here, returning a boolean
# end

# uncomment and implement your logic here to avoid/permit email sending to your users
# leave it commented if you always want your users received notifications
# Wupee.notification_sending_rule = Proc.new do |receiver, notification_type| 
#   # logic goes here, returning a boolean
# end