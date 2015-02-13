FactoryGirl.define do
  factory :notification do
    association :receiver, strategy: :create
    association :attached_object, strategy: :create
    notification_type_id NotifyWith::NotificationType.find_by_name('notify_new_message')
  end
end
