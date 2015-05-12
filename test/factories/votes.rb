FactoryGirl.define do
  factory :vote, class: ActsAsVotable::Vote do
    association :voter, factory: :user

    trait :for_question do
      association :votable, factory: :question
    end

    trait :for_answer do
      association :votable, factory: :answer
    end
  end
end