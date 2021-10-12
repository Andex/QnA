FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password { '121212' }
    password_confirmation { '121212' }
    confirmed_at { Time.zone.now }
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
