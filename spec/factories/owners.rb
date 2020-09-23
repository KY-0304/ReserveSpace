FactoryBot.define do
  factory :owner do
    sequence(:email)        { |n| "owner#{n}@example.com" }
    sequence(:company_name) { |n| "company#{n}" }
    password                { "password" }
    password_confirmation   { "password" }
  end
end
