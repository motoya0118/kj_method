require 'faker'

User.create(
  email: 'guest@example.com',
  password: 'm1234m',
  password_confirmation: 'm1234m',
  name: 'hoge',
  nickname: 'fuga',
)

Thema.create(
  name: 'カード化済',
  purpose: 'カード化されていることを確認',
  user_id: User.find_by(name: 'hoge').id
)

5.times do
  Question.create(
    question: Faker::Games::SuperMario.character,
    thema_id: Thema.last.id
  )
end

Thema.last.update(lock: true)

question_ids = Question.all.ids

5.times do
  User.create(
    email: Faker::Internet.email,
    name: Faker::Games::Pokemon.name,
    nickname: Faker::Games::Pokemon.name,
    password: 'm1234m',
    password_confirmation: 'm1234m'
  )
  question_ids.each do |id|
    5.times do
      Answer.create(
        user_id: User.last.id,
        answer: Faker::Hobby.activity,
        question_id: id
      )
    end
  end
end

Place.create(
  thema_id: Thema.last.id,
  user_id: User.find_by(name:'hoge').id
)

contents = []
contents_list = []
ct = 0
Question.all.each.with_index do |question,index|
  question.answers.each do |answer|
    contents <<  "質問#{index}\n#{answer.answer}"
    ct += 1
    if ct == 10
      ct = 0
      contents_list << contents
      contents = []
    end
  end
end

unless ct == 0
  contents_list << contents
end
contents_list.each do |contents|
  LargeGroup.create(
    place_id: Place.last.id,
    name: Faker::Games::SuperSmashBros.fighter
  )
  SmallGroup.create(
    large_group_id: LargeGroup.last.id,
    name: Faker::Games::SuperSmashBros.fighter
  )
  contents.each do |content|
    Card.create(
      small_group_id: SmallGroup.last.id,
      content: content
    )
  end
end

Thema.create(
  name: 'カード化未',
  purpose: 'カード化される前の状態を確認',
  user_id: User.find_by(name: 'hoge').id
)

5.times do
  Question.create(
    question: Faker::Games::SuperMario.character,
    thema_id: Thema.last.id
  )
end

Thema.last.update(lock: true)
user_ids = User.all.ids
Thema.last.questions.each do |question|
  user_ids.each do |id|
    Answer.create(
      question_id: question.id,
      answer: Faker::Hobby.activity,
      user_id: id
    )
  end
end





