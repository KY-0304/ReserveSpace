FactoryBot.define do
  factory :favorite do
    association :user
    association :room
  end
end
