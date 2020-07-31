FactoryBot.define do
  factory :review do
    association :space
    association :user
    rate { 2 }
    comment { "テストコメント" }
  end
end
