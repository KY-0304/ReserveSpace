FactoryBot.define do
  factory :review do
    association :space
    association :user
    rate    { rand(0..4) }
    comment { "レビューコメント" }
  end
end
