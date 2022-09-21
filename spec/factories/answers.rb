FactoryBot.define do
  factory :answer do
    answer { "Answer_No_1" }
  end
  factory :answer2, class: 'Answer' do
    answer { "Answer_No_2" }
  end
  factory :answer3, class: 'Answer' do
    answer { "Answer_No_3" }
  end
end
