FactoryBot.define do
  factory :small_group do
    name { "Small_Test_Group" }
    position { 1 }
    edit { false }
    large_group_id {LargeGroup.last.id}
  end
end
