# Wupee

Wupee is a simple gem which tries to fill the gap of lacking gems to manage **notifications** in Rails app.
Wupee is a opinionated solution which assumes that users needs to:

* be able to receive notifications in the app
* be able to receive notifications by mail
* be able to configure if they wants to either receive emails AND notifications or emails or only notifications or nothing

Right now, only the receiver can configure what he wants to receive. You can't create an *email only* notification or a *app only* notification but that could be a near future feature. 

The main object of the solution is the <strong>Wupee::Notification which stores</strong>:
* receiver (polymorphic): the recipient of the message
* attached_object (polymorphic): the subject of the notification
* notification_type_id: a reference to a Wupee::NotificationType object
* is_read: bolean

 
## Install:

To use it, add it to your Gemfile:
```ruby
gem 'wupee'
```

and bundle:
```bash
$ bundle
```

Run the generator, install migrations and migrate:

```bash
$ rails g wupee:install
$ rake wupee:install:migrations
$ rake db:migrate
```

Running the generator will do a few things:

1. add the engine routes to your routes.rb:

  ```ruby
  # config/routes.rb
  mount Wupee::Engine, at: "/wupee"
  ```
2. create wupee initializer:

  ```ruby
  # config/initializers/wupee.rb
  Wupee.mailer = NotificationsMailer
  Wupee.deliver_when = :now
  ```
3. create a mailer NotificationsMailers which inheritates from Wupee::NotificationsMailer

  ```ruby
  # app/mailers/notifications_mailers.rb
  Wupee.mailer = NotificationsMailer
  Wupee.deliver_when = :now
  ```
  
4. adds wupee to your locale yml file (for email subjects)
  ```yml
  # config/locales/en.yml
  en:
    wupee:
      email_subjects:
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
