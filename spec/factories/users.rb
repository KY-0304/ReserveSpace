FactoryBot.define do
  factory :user do
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              { "password" }
    password_confirmation { "password" }
    name                  { Gimei.male.kanji }
    phone_number          { "080-#{rand(1000..9999)}-#{rand(1000..9999)}" }
    gender                { :male }
  end
end
