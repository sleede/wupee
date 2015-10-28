FactoryGirl.define do
  factory :notification, class: NotifyWith::Notification do
    association :receiver, factory: :user, strategy: :create
    association :attached_object, factory: :message, strategy: :create
    notification_type { NotifyWith::NotificationType.find_or_create_by(name: 'notify_new_message') }
  end
end
