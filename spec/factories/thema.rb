FactoryBot.define do
  factory :thema, class: 'Thema' do
    name {'thema_name'}
    purpose {'thema_purpose'}
    user_id {User.last.id}
  end
  factory :thema_lock_true, class: 'Thema' do
    name {'test_flag'}
    purpose {'test_flag'}
    lock {true}
    user_id {User.last.id}
  end
end