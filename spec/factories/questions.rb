FactoryBot.define do
  sequence :title do |n|
    "MyString #{n}"
  end
  sequence :body do |n|
    "MyText #{n}"
  end
  factory :question do
    title
    body
    user

    trait :invalid do
      title { nil }
    end
  end
end
