class NotifyWith::NotificationGenerator < Rails::Generators::NamedBase
  def add_notification_type
    inject_into_file 'app/models/notification_type.rb', before: /  \)/ do
<<-CODE
    #{file_name}
CODE
    end
  end

  def create_notification_mail_template_file
    create_file "app/views/notifications_mailer/#{file_name}.html.erb", <<-FILE
<%# this is a mail template of notifcation #{file_name} %>
<p><%= @recipient.name %></p>
<p><%= @attached_object.body %></p>
    FILE
  end

  def add_notification_subject
    inject_into_file "config/locales/#{I18n.locale.to_s}.yml", after: /send_mail_by:\n/ do
<<-CODE
      subject_#{file_name}: "#{file_name}"
CODE
    end
  end

  def create_notification_json_template_file
    create_file "app/views/api/notifications/_#{file_name}.json.jbuilder", <<-FILE
json.title notification.notification_type
json.description 'a notification description'
json.url 'a url for redirect to attached_object'
    FILE
  end
end
