# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(username:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.all
20.times do
  title = "What's the best #{Faker::Hacker.noun} for #{Faker::Hacker.ingverb} #{Faker::Hacker.adjective} #{Faker::Hacker.noun.pluralize}"
  description = Faker::Lorem.sentence(5)
  users.sample.questions.create!(title: title, description: description)
end

questions = Question.all
40.times do
  content = "I think #{Faker::Hacker.noun.pluralize} are the best because they are the most #{Faker::Hacker.adjective}"

  # Because we cannot answer our own questions, get two different users
  user_one = users.sample
  until user_one != (user_two = users.sample) do end
    
  user_one.answers.create!(content: content, question: user_two.questions.sample)
end