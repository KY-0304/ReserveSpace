class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_rooms, through: :favorites, source: :room
  has_many :reviews
  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :gender, presence: true
  enum gender: { unanswered: 0, female: 1, male: 2 }

  def favorite?(room)
    favorite_rooms.include?(room)
  end
end
