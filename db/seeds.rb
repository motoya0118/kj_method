require 'faker'
5.times do
  User.create(
    email: Faker::Internet.email,
    name: Faker::Games::Pokemon.name,
    nickname: Faker::Games::Pokemon.name,
    password: 'm1234m',
    password_confirmation: 'm1234m'
  )
  5.times do
    Answer.create(
      user_id: User.last.id,
      answer: Faker::Hobby.activity,
      question_id: Question.last.id
    )
  end
end
