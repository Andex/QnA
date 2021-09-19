FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    password { '121212' }
    password_confirmation { '121212' }
  end

  trait :with_rewards do
    transient do
      reward_count { 2 }
    end

    after(:create) do |user, evaluator|
      create_list(:reward, evaluator.reward_count, user: user)
    end
  end
end
