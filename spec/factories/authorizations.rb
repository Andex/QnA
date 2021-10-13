FactoryBot.define do
  factory :authorization do
    user
    provider { 'github' }
    uid { '123' }
  end
end
