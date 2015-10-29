class Wupee::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_notifications_mailer
    template "notifications_mailer.rb", "app/mailers/notifications_mailer.rb"
  end

  def add_wupee_routes
    route 'mount Wupee::Engine, at: "/wupee"'
  end

  def copy_initializer
    template "wupee.rb", "config/initializers/wupee.rb"
  end

  def add_subject_locale
    append_file "config/locales/#{I18n.locale.to_s}.yml" do
      <<-CODE
        wupee:
          email_subjects:
      CODE
    end
  end
end
