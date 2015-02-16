FactoryGirl.define do
  factory :notification do
    association :receiver, factory: :user, strategy: :create
    association :attached_object, factory: :message, strategy: :create
    notification_type_id NotificationType.find_by_name('notify_new_message')
  end
end
