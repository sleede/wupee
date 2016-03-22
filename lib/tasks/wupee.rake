namespace :wupee do
  desc "generate Wupee::NotificationTypeConfiguration objects for given Wupee::NotificationType name and for all receivers of given class (default to User)"
  task :generate_notification_type_configurations, [:notification_type_name, :receiver_klass] => [:environment] do |t, args|

    unless notification_type = Wupee::NotificationType.find_by(name: args[:notification_type_name])
      warn "Wupee::NotificationType with name #{args[:notification_type_name]} not found."
      next
    end

    receiver_klass = args[:receiver_klass] || 'User'

    receiver_klass.constantize.pluck(:id).each do |id|
      Wupee::NotificationTypeConfiguration.create!(receiver_type: receiver_klass, receiver_id: id, notification_type_id: notification_type.id)
    end
  end
end
