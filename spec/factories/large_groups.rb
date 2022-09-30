FactoryBot.define do
  factory :large_group do
    name { "MyString" }
    position { 1 }
    edit { false }
    place_id {Place.last.id}
  end
end
