FactoryBot.define do
  sequence :body_answer do |n|
    "MyTextAnswer-#{n}"
  end
  factory :answer do
    body { generate(:body_answer) }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
