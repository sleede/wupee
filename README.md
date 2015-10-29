# Wupee
==========
Very simple rails notification system (send a mail and a controller for render json) for sleede project.

## Install:
```ruby
gem 'wupee'
```
```bash
$ rails g wupee:install
$ rake db:migrate
```

## Getting started:
### 1. Generate notification type
```bash
rails g wupee:notification notify_new_message
```
### 2. Edit mail template and json template
Edit app/views/notifications_mailer/notify_new_message.html.erb

Edit config/locales/{locale}.yml

Edit app/views/api/notifications/_notify_new_message.json.jbuilder

### 3. Build a notifcation:
```ruby
receiver = User.create(email: 'contact@sleede.com')
message = Message.create(body: 'this a message')
notification = Notification.new.send_notification(type: 'notify_new_message', attached_object: message)
                .to(receiver)
```
### 4. Save and send a notifcation:
To save and send:
```ruby
notification.deliver_now
```
or
```ruby
notification.deliver_later
```
### 5. Utility
```ruby
class Message < ActiveRecord::Base
  include Wupee::NotificationAttachedObject
end
# can destroy all notifications attached is message
message.destroy
```
```ruby
class User < ActiveRecord::Base
  include Wupee::NotificationReceiver
end
user.notifications
# => [list of notifications]
```

## Testing:
```bash
$ rake
```

This project rocks and uses MIT-LICENSE.
