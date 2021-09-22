FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "MyString #{n}" }
    sequence(:body) { |n| "MyText #{n}" }
    user
    best_answer { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_best_answer do
      best_answer factory: :answer
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

    trait :with_reward do
      reward factory: :reward
    end
  end
end
