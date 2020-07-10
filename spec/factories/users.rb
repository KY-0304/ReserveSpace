FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    sequence(:name) { |n| "テストユーザー#{n}" }
    phone_number { "080-1234-1234" }
    gender { 1 }
  end
end
