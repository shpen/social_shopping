# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create users
ActiveRecord::Base.transaction do
  10.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@example.org"
    password = "password"
    User.create!(username:  name,
                 email: email,
                 password:              password,
                 password_confirmation: password)
  end
end
users = User.all

# Ask questions
ActiveRecord::Base.transaction do
  50.times do
    noun = Faker::Hacker.noun
    verb = Faker::Hacker.ingverb
    noun2 = Faker::Hacker.noun.pluralize
    title = "What's the best #{noun} for #{verb} #{Faker::Hacker.adjective} #{noun2}"
    description = Faker::Lorem.sentence(5)
    tags = "#{noun}, #{verb}, #{noun2}"
    users.sample.questions.create!(title: title, description: description, tag_list: tags)
  end
end
questions = Question.all

# Answer questions
ActiveRecord::Base.transaction do
  200.times do
    link = "http://www.#{Faker::Hacker.adjective}#{Faker::Hacker.noun.pluralize}.com/product/#{(0..99999).to_a.sample}"
    content = "I think #{Faker::Hacker.noun.pluralize} are the best because they are the most #{Faker::Hacker.adjective}\n#{link}"

    # Because we cannot answer our own questions, get two different users
    user_one = users.sample
    until user_one != (user_two = users.sample) && !user_two.questions.empty? do end
      
    user_one.answers.create!(content: content, question: user_two.questions.sample)
  end
end
answers = Answer.all

# Vote
ActiveRecord::Base.transaction do
  users.each do |user|
    questions.each do |question|
      if question.user != user
        if [true, false].sample
          user.up_votes question
        else
          user.down_votes question
        end
      end
    end

    answers.each do |answer|
      if answer.user != user
        if [true, false].sample
          user.up_votes answer
        else
          user.down_votes answer
        end
      end
    end
  end
end

# Make friends
ActiveRecord::Base.transaction do
  requests = {}
  users.each do |user1|
    users.each do |user2|
      if [true, false].sample && user1 != user2
        (requests[user1] ||= []) << user2
      end
    end
  end

  handled = {}
  requests.each do |user1, friends|
    friends.each do |user2|
      if requests[user2].include?(user1)
        handled[user1] ||= []
        handled[user2] ||= []
        unless handled[user1].include?(user2) || handled[user2].include?(user1)
          user1.friends << user2
          user2.friends << user1
          handled[user1] << user2
          handled[user2] << user1
        end
      else
        user1.friend_requests.create(friend: user2)
      end
    end
  end
end