# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :integer          default("unanswered"), not null
#  name                   :string           not null
#  phone_number           :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
