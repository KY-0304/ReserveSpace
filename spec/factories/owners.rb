# == Schema Information
#
# Table name: owners
#
#  id                     :bigint           not null, primary key
#  company_name           :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_owners_on_company_name          (company_name) UNIQUE
#  index_owners_on_email                 (email) UNIQUE
#  index_owners_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :owner do
    sequence(:email)        { |n| "owner#{n}@example.com" }
    sequence(:company_name) { |n| "company#{n}" }
    password                { "password" }
    password_confirmation   { "password" }
  end
end
