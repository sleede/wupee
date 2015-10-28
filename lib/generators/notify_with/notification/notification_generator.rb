class NotifyWith::NotificationGenerator < Rails::Generators::NamedBase
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
json.title notification.notification_type.name
json.description 'a notification description'
json.url 'a url for redirect to attached_object'
    FILE
  end

  def create_notification_html_template_file
    create_file "app/views/notifications/_#{file_name}.html.erb", <<-FILE
    FILE
  end

  def create_notification_type_object
    NotifyWith::NotificationType.create!(name: file_name)
  end
end
