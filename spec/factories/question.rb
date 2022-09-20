FactoryBot.define do
  factory :question do
    question { 'question' }
    association :thema
  end
end