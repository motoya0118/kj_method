FactoryBot.define do
  factory :question do
    question { 'question1' }
    association :thema
  end
  factory :question_lock_true, class: 'Question' do
    question { 'question_flag_true' }
    association :thema, factory: :thema_lock_true
  end
  factory :question_lock_false, class: 'Question' do
    question { 'question_flag_false' }
    association :thema
  end
  factory :question_only, class: 'Question' do
    question { 'only' }
  end
end