FactoryBot.define do
  factory :review do
    association :room
    association :user
    rate { 2 }
    comment { "テストコメント" }
  end
end
