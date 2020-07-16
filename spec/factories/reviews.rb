FactoryBot.define do
  factory :review do
    room { nil }
    user { nil }
    rate { 1.5 }
    comment { "MyText" }
  end
end
