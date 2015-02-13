FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@sleede.com" }
  sequence(:name) { |n| "user#{n}" }

  factory :user do
    email { FactoryGirl.generate :email }
    name { FactoryGirl.generate :name }
  end
end
