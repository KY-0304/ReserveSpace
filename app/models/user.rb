class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_rooms, through: :favorites, source: :room
  has_many :reviews, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :phone_number
    validates :gender
  end

  validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :agreement, acceptance: true

  enum gender: { unanswered: 0, female: 1, male: 2 }

  def favorite?(room)
    favorite_rooms.include?(room)
  end
end
