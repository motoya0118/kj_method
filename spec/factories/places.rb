FactoryBot.define do
  factory :place do
    leader { false }
    association :large_group
  end
  factory :place_thema, class: 'Place' do
    leader { false }
    user_id {User.last.id}
    thema_id {Thema.last.id}
  end
end
