FactoryBot.define do
  factory :answer do
    answer { "Answer_No_1" }
    user_id {User.last.id}
  end
  factory :answer2, class: 'Answer' do
    answer { "Answer_No_2" }
    user_id {User.last.id}
  end
  factory :answer3, class: 'Answer' do
    answer { "Answer_No_3" }
    user_id {User.last.id}
  end
end
