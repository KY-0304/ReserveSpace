class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  before_destroy :check_all_reservations_finished

  has_many :reservations, dependent: :destroy
  has_many :reviews,      dependent: :destroy
  has_many :favorites,    dependent: :destroy
  has_many :favorite_spaces, through: :favorites, source: :space

  with_options presence: true do
    validates :name,         length: { maximum: MAX_USER_NAME_LENGTH }
    validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX }
    validates :gender
  end

  validates :email, length: { maximum: MAX_EMAIL_LENGTH }
  validates :agreement, acceptance: true

  enum gender: { unanswered: 0, female: 1, male: 2 }

  def favorite?(space)
    favorite_spaces.include?(space)
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name         = "ゲストユーザー"
      user.password     = "password"
      user.phone_number = "080-1111-1111"
      user.gender       = :male
    end
  end

  private

  def check_all_reservations_finished
    if reservations.unfinished.exists?
      throw(:abort)
    end
  end
end
