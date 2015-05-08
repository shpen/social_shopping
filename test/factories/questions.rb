FactoryGirl.define do
  factory :question do
    user
    sequence(:title) { |n| "Question Title #{n}" }
=begin
    before(:create) do |instance|
      instance.tags << create(:tag)
    end
=end
  end
end