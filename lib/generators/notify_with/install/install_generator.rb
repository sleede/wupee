class NotifyWith::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number path
    unless @prev_migration_nr
      @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
    else
      @prev_migration_nr += 1
    end
    @prev_migration_nr.to_s
  end

  def copy_notifications_migration
    migration_template "create_notifications.rb", "db/migrate/create_notifications.rb"
  end

  def copy_notification_types_migration
    migration_template "create_notification_types.rb", "db/migrate/create_notification_types.rb"
  end

  def copy_notification_type_configurations_migration
    migration_template "create_notification_type_configurations.rb", "db/migrate/create_notification_type_configurations.rb"
  end

  def copy_notifications_mailer
    template "notifications_mailer.rb", "app/mailers/notifications_mailer.rb"
  end

  # def copy_api_notifications_controller
  #   template "notifications_controller.rb", "app/controllers/api/notifications_controller.rb"
  # end

  # def copy_api_notifications_views
  #   template "index.json.jbuilder", "app/views/api/notifications/index.json.jbuilder"
  #   template "show.json.jbuilder", "app/views/api/notifications/show.json.jbuilder"
  # end

  # def add_notifications_route
  #   route \
  #     <<-CODE
  #     namespace :api, defaults: { format: :json } do
  #         resources :notifications, only: [:index, :show, :update] do
  #           match :update_all, path: '/', via: [:put, :patch], on: :collection
  #         end
  #       end
  #     CODE
  # end

  def add_notify_with_routes
    route 'mount NotifyWith::Engine, at: "/notify_with"'
  end

  def copy_initializer
    template "notify_with.rb", "config/initializers/notify_with.rb"
  end

  def add_subject_locale
    append_file "config/locales/#{I18n.locale.to_s}.yml" do
      <<-CODE
        notifications_mailer:
          send_mail_by:
      CODE
    end
  end
end
