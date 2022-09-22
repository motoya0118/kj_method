FactoryBot.define do
  factory :card do
    SmallGroup { nil }
    content { "MyString" }
    position { 1 }
    edit { false }
  end
end
