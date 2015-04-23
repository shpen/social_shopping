# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(username:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(6)
50.times do
  title = "What's the best #{Faker::Hacker.noun} for #{Faker::Hacker.ingverb} #{Faker::Hacker.adjective} #{Faker::Hacker.noun.pluralize}"
  description = Faker::Lorem.sentence(5)
  users.sample.questions.create!(title: title, description: description)
end