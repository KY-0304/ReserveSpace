FactoryBot.define do
  factory :owner do
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:company_name) { |n| "test#{n}_company" }
    password { "password" }
    password_confirmation { "password" }
  end
end
