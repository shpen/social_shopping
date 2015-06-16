FactoryGirl.define do
  factory :comment do
    user
    content "content"

    trait :for_question do
      association :commentable, factory: :question
    end

    trait :for_answer do
      association :commentable, factory: :answer
    end
  end
end