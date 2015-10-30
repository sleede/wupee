class Wupee::NotificationGenerator < Rails::Generators::NamedBase
  def add_notification_subject
    inject_into_file "config/locales/#{I18n.locale.to_s}.yml", after: /email_subjects:\n/ do
<<-CODE
      #{file_name}: "#{file_name}"
CODE
    end
  end

  def create_notification_json_template_file
    create_file "app/views/wupee/api/notifications/_#{file_name}.json.jbuilder", <<-FILE
json.subject notification.notification_type.name
json.body "body"
json.url "url"
    FILE
  end

  def create_notification_html_template_file
    create_file "app/views/wupee/notifications/_#{file_name}.html.erb", <<-FILE
    FILE
  end

  def create_notification_type_object
    Wupee::NotificationType.create!(name: file_name)
  end
end
