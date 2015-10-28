FactoryGirl.define do
  factory :notification_type, class: NotifyWith::NotificationType do
    name 'notify_new_message'
  end
end
