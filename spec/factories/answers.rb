FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyTextAnswer-#{n}" }
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

    trait :with_comments do
      after(:create) do |answer|
        create(:comment, commentable: answer)
      end
    end
  end
end
