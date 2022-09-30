FactoryBot.define do
  factory :user do
    name {'motoya'}
    nickname {'puchanpig'}
    email {'motoya@gmail.com'}
    password {'m1234m'}
    password_confirmation {'m1234m'}
    provider {'twitter'}
    uid {'111111'}   
  end
end
