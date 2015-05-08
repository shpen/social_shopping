FactoryGirl.define do
  factory :question do
    user
    sequence(:title) { |n| "Question Title #{n}" }
    tag_list "tag"
=begin
    before(:create) do |question|
      question.update_attributes(tag_list: "tag")
    end
=end
=begin
    before(:create) do |instance|
      instance.tags << create(:tag)
    end
=end
  end
end