FactoryGirl.define do
  factory :answer do
    user
    question
    sequence(:link) { |n| "http://www.url#{n}.com" }
    sequence(:content) { |n| "Content ##{n}" }
  end
end