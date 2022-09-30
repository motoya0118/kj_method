FactoryBot.define do
  factory :card do
    content { "MyString" }
    position { 1 }
    edit { false }
    association :small_group
  end
end
