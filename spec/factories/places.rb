FactoryBot.define do
  factory :place do
    leader { false }
    association :large_group
  end
end
