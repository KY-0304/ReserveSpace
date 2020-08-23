class Owner < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_destroy :check_all_space_destroyed
  has_many :spaces, dependent: :destroy

  validates :company_name, length: { maximum: 140 }, presence: true, uniqueness: true
  validates :email,        length: { maximum: 255 }
  validates :agreement, acceptance: true

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |owner|
      owner.company_name = "ReserveSpace株式会社"
      owner.password = "password"
    end
  end

  private

  def check_all_space_destroyed
    throw(:abort) unless spaces.empty?
  end
end
