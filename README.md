# Breaking changes

After using this gem in a few projects, I realized that all projects have different needs concerning the configuration of notifications (whether or not the user should received a notification or an email). We have apps which doesn't have the need for configuration so we are having a lots of Wupee::NotificationTypeConfiguration created and fetched from db for nothing. I really feel that the app should be responsible for addressing this. 
Also, in some apps, I had to reopen classes to override default behaviour of the gem or skip callbacks and adding others and I was feeling that something was wrong. See [this issue](https://github.com/sleede/wupee/issues/7) for another example.
Therefore, this branch removes all Wupee::NotificationTypeConfiguration but leaves a door open to customization, see [Wupee initializer](#initializer).


# Wupee

Wupee is a simple gem which tries to fill the gap of lacking gems to manage **notifications** in Rails app.
Wupee is an opinionated solution which assumes that users needs to:

* be able to receive notifications in the app
* be able to receive notifications by email

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
2. create <a name="initializer">wupee initializer</a>:

  ```ruby
  # config/initializers/wupee.rb
  Wupee.mailer = NotificationsMailer # the class of the mailer you will use to send the emails
  Wupee.deliver_when = :now # use :later if you already configured a queuing system
 
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

4. You will have to create your email template as the generator doesn't create it.
 For example, if your mailer is named `NotificationsMailer`, your template will take place in
 `app/views/notifications_mailer/user_has_been_created.html.erb`


### Use the concerns

#### Wupee::Receiver

Including the concern `Wupee::Receiver` in your receiver class (probably the `User` class) permits a few things:
 * get notifications of a user: `@user.notifications`
 * destroy `Wupee::Notification` associated to the receiver from db if it is destroyed

#### Wupee::AttachedObject

Including the concern `Wupee::AttachedObject` in your attached object classe(s) permits a few things:
 * get notifications associated to an attached object: `@attached_object.notifications_as_attached_object`
 * destroy `Wupee::Notification` associated to the attached object if it is destroyed

### Use the DSL to send notifications

Imagine that you want to notify all admin that a new user signed up in your app and that you have a scope `admin` in your `User` class.

```ruby
 Wupee.notify do |n|
   n.attached_object @the_new_user
   n.notif_type :user_has_been_created # you can also pass an instance of a Wupee::NotificationType class to this method
   n.subject_vars user_full_name: Proc.new { |notification| notification.attached_object.full_name } # variables to be interpolated the fill in the subject of the email (obviously optional)
   n.locals extra_data: "something" # extra_data will be accessible in template as @locals[:extra_data]
   n.receivers User.admin # you can use the method receiver instead of receivers for clarity if you pass only one instance of a receiver
   n.deliver :now # you can overwrite global configuration here, optional
 end
```

You can also use the method `notify` this way:

```ruby
 Wupee.notify attached_object: @the_new_user, notif_type: :user_has_been_created, subject_vars: { user_full_name: Proc.new { |notification| notification.attached_object.full_name } }, locals: { extra_data: "Yeahhhhh" }, receivers: User.admin
```

## Wupee::Api::NotificationsController

The controller have various actions all scoped for the current user:
 * `wupee/api/notifications#index` : fetch notifications, take an optional parameter `is_read` (false by default)
 * `wupee/api/notifications#show` : fetch a notification
 * `wupee/api/notifications#mark_as_read` : mark as read a notification
 * `wupee/api/notifications#mark_all_as_read` : mark as read all notifications

To use this controller, define a controller inheriting from `Wupee::Api::NotificationsController`, set the routes in your `config/routes.rb` 
and define a method `current_user`  which returns the user signed in.

## Why WUPEE ?

**W**hat's **UP** Sl**EE**de

## License

This project rocks and uses MIT-LICENSE.
