FactoryBot.define do
  factory :link do
    name { 'My github' }
    url { 'https://github.com/Andex' }
    linkable factory: :question
  end

  trait :gist do
    url { 'https://gist.github.com/Andex/adaaec3cd7d9e72b9e4d3a89465aeb34' }
  end
end
