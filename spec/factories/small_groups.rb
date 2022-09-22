FactoryBot.define do
  factory :small_group do
    large_group { nil }
    name { "MyString" }
    position { 1 }
    edit { false }
  end
end
