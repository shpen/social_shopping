FactoryGirl.define do
  factory :answer do
    user
    question
    sequence(:content) { |n| "Content ##{n}" }
  end
end