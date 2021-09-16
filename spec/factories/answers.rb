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

    trait :with_files do
      after(:create) do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end

    trait :with_links do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end
  end
end
