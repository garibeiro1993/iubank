FactoryBot.define do
  factory :account do
    name         { FFaker::Lorem.word }
    balance      { rand(10000..100000) }
    email        { FFaker::Internet.email }
    password     'secret123'
  end
end
