FactoryGirl.define do
  factory :notification, class: Wupee::Notification do
    association :receiver, factory: :user, strategy: :create
    association :attached_object, factory: :message, strategy: :create
    notification_type { Wupee::NotificationType.find_or_create_by(name: 'notify_new_message') }
  end
end
