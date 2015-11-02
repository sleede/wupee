# Wupee

Wupee is a simple gem which tries to fill the gap of lacking gems to manage **notifications** in Rails app.
Wupee is a opinionated solution which assumes that users needs to:

* be able to receive notifications in the app
* be able to receive notifications by email
* be able to configure if they wants to either receive emails AND notifications or emails or only notifications or nothing

Right now, only the receiver can configure what he wants to receive. You can't create an *email only* notification or a *app only* notification but that could be a near future feature. 

The main object of the solution is the `Wupee::Notification` which stores:
* receiver (polymorphic): the recipient of the message
* attached_object (polymorphic): the subject of the notification
* notification_type_id: a reference to a `Wupee::NotificationType` object
* is_read: boolean

 
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
  Wupee.mailer = NotificationsMailer # the class of the mailer you will use to send the emails
  Wupee.deliver_when = :now # use :later if you already configured a queuing system
  
  Wupee::NotificationType.class_eval do
    create_configurations_for 'User' # class name of your notification receivers, can be various 'User', 'Admin',
  end                                # enable callbacks to create Wupee::NotificationTypeConfiguration object of 
  # each user when you create a new Wupee::NotificationType
  ```
3. create a mailer `NotificationsMailer` which inheritates from `Wupee::NotificationsMailer`

  ```ruby
  # app/mailers/notifications_mailer.rb
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
 # none of this json attribute are mandatory! 
 ```
 In this template, you have access to the **notification** variable.
 You can customize it to fit your need, this is just an example.
 
3. create an empty html template for the notification:
```html
<!-- app/views/wupee/notifications/_user_has_been_created.html.erb -->
```
 
You will have to create your email template as the generator doesn't create it. 
For example, if your mailer is named `NotificationsMailer`, your template will take place in
`app/views/notifications_mailer/user_has_been_created.html.erb`

### Understand the Wupee::NotificationTypeConfiguration model

An object of the class `Wupee::NotificationTypeConfiguration` references/stores:
* receiver (polymorphic)
* notification_type (object of class `Wupee::NotificationType`)
* value (an enum)

The attribute **value** can be:
* 'both' : the receiver wants notifications **AND** emails of the `Wupee::NotificationType` type
* 'nothing' : the receiver doesn't want to receive **nothing** from the `Wupee::NotificationType` type
* 'email' : the receiver wants to receive **only** emails
* 'notification' : the receiver wants to receive **only** notifications

Just let the user edit this object to make him able to activate/deactivate notifications or emails.

### Use the concerns

#### Wupee::Receiver

Including the concern `Wupee::Receiver` in your receiver class (probably the `User` class) permits a few things:
 * get notifications of a user: `@user.notifications`
 * get notifications_type_configurations of a user: `@user.notifications_type_configurations`
 * execute an after_create callback to create `Wupee::NotificationTypeConfiguration` for each `Wupee::NotificationType` object for the receiver
 * destroy `Wupee::Notification` and `Wupee::NotificationTypeConfiguration` associated to the receiver from db if it is destroyed
 
#### Wupee::AttachedObject

Including the concern `Wupee::AttachedObject` in your attached object classe(s) permits a few things:
 * get notifications associated to an attached object: `@attached_object.notifications_as_attached_object`
 * destroy `Wupee::Notification` associated to the attached object if it is destroyed

### Use the DSL to send notifications

Imagine that you want to notify all admin that a new user signed up in your app and that you have a scope `admin` in your `User` class.

```ruby
 Wupee.notify do
   attached_object @the_new_user
   notif_type :user_has_been_created # you can also pass an instance of a Wupee::NotificationType class to this method
   subject_vars user_full_name: Proc.new { |notification| notification.attached_object.full_name } # variables to be interpolated the fill in the subject of the email (obviously optional)
   receivers User.admin # you can use the method receiver instead of receivers
   deliver :now # you can overwrite global configuration here, optional
 end
```

You can also use the method `notify` this way:

```ruby
 Wupee.notify attached_object: @the_new_user, notif_type: :user_has_been_created, subject_vars user_full_name: Proc.new { |notification| notification.attached_object.full_name }, receivers: User.admin
```

The method will take care to check receiver's configurations to only send emails to those who want them.

## Wupee::Api::NotificationsController 

In order to make this controller work, you need a method `current_user` which return the user currently signed in.

The controller have various actions all scoped for the current user:
 * `wupee/api/notifications#index` : fetch notifications, take an optional parameter `is_read` (false by default) 
 * `wupee/api/notifications#show` : fetch a notification
 * `wupee/api/notifications#update` : mark as read a notification
 * `wupee/api/notifications#update_all` : mark as read all notifications

## Wupee::NotificationTypeConfiguration

The class also define 2 methods which you could use (in your views for example):
 * `wants_email?` : return a boolean
 * `wants_notification?` : return a boolean
 
## Important to know!

The system relies on the fact that you have an object in db for each couple of [receiver, `Wupee::NotificationType`]. Even if the gem provides callbacks to take care of that, be sure that those objects are created otherwise notifications won't be sent for thoses receivers.

## License

This project rocks and uses MIT-LICENSE.
