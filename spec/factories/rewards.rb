FactoryBot.define do
  factory :reward do
    sequence(:title) { |n| "Reward #{n}" }
    question
    user { nil }

    before(:create) do |reward|
      reward.image.attach(io: File.open("#{Rails.root}/spec/files/reward.png"), filename: 'reward.png')
    end
  end
end
