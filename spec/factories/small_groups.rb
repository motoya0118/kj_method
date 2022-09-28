FactoryBot.define do
  factory :small_group do
    large_group { nil }
    name { "Small_Test_Group" }
    position { 1 }
    edit { false }
  end
end
