NotifyWith
==========
A simple notification system (send a mail and a controller for render json) for sleede rails project.

Install:
```
gem 'notify_with'
rails g notify_with:install
rake db:migrate
```

Getting started:
```
rails g notify_with:notification notify_new_message
```
Edit app/views/notifications_mailer/notify_new_message.html.erb

Edit config/locales/{locale}.yml

Edit app/views/api/notifications/_notify_new_message.json.jbuilder

To send:
```
receiver = User.create(email: 'contact@sleede.com')
message = Message.create(body: 'this a message')
Notification.new.send_notification(type: 'notify_new_message', attached_object: message)
                .to(receiver)
```

To test:
```
rake
```

This project rocks and uses MIT-LICENSE.
