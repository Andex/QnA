FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    password { '121212' }
    password_confirmation { '121212' }
  end
end
