FactoryGirl.define do
  factory :notification, class: NotifyWith::Notification do
    association :receiver, factory: :user, strategy: :create
    association :attached_object, factory: :message, strategy: :create
    notification_type_id NotifyWith::NotificationType.find_by_name('notify_new_message')
  end
end
