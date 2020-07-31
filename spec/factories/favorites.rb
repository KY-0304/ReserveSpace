FactoryBot.define do
  factory :favorite do
    association :user
    association :space
  end
end
