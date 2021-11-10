FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "My Comment-#{n}" }
    user
    commentable factory: :question

    trait :invalid do
      body { nil }
    end
  end
end
