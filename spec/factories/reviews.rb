FactoryBot.define do
  factory :review do
    association :room
    association :user
    rate { 3.0 }
    comment { "テストコメント" }
  end
end
