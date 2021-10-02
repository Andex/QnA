FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "MyComment-#{n}" }
    user
    commentable factory: :question
  end
end
