FactoryGirl.define do
  factory :friend_request do
    user
    association :friend, factory: :user
  end
end