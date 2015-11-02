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
  class NotificationsMailer < Wupee::NotificationsMailer
    default from: 'contact@sleede.com'
    layout false
 end
  ```
  
4. adds wupee to your locale yml file (for email subjects)
  ```yml
  # config/locales/en.yml
  en:
    wupee:
      email_subjects:
  ```

## Getting started:

### Generate a new notification type 

```bash
rails g wupee:notification_type user_has_been_created
```

Will execute a few things:

1. add an entry to your locale yml file :

 ```yml
 en:
   wupee:
     email_subjects:
       user_has_been_created: "user_has_been_created" 
 ```
 Feel free to edit the subject, you can put variables, example
 ```yml
  ...
      user_has_been_created: "New user created: %{user_full_name}"
 ```
 
2. create a json template for the notification:

 ```ruby
 json.subject ""
 json.body ""
 json.url ""
 ```
 In this template, you have access to the **notification** variable.
 You can customize it to fit your need, this is just an example.
 
3. create an empty html template for the notification:
```html
<!-- app/views/wupee/notifications/_user_has_been_created.html.erb -->
```
 


This project rocks and uses MIT-LICENSE.
