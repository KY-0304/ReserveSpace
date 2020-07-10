class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :gender, presence: true
  enum gender: { male: 0, female: 1, unanswered: 2 }
end
