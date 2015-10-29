FactoryGirl.define do
  factory :notification_type_configuration, class: Wupee::NotificationTypeConfiguration do
    association :receiver, factory: :user, strategy: :create
    association :notification_type, factory: :notification_type, strategy: :create
  end
end
