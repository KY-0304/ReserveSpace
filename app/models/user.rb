class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :favorites
  has_many :rooms, through: :favorites
  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :gender, presence: true
  enum gender: { unanswered: 0, female: 1, male: 2 }
end
