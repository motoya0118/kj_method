FactoryBot.define do
  factory :thema, class: 'Thema' do
    name {'thema_name'}
    purpose {'thema_purpose'}
  end
  factory :thema_lock_true, class: 'Thema' do
    name {'test_flag'}
    purpose {'test_flag'}
    lock {true}
  end
end