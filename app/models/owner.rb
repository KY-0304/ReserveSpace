class Owner < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :spaces, dependent: :destroy

  validates :company_name, length: { maximum: 140 }, presence: true, uniqueness: true
  validates :email,        length: { maximum: 255 }
  validates :agreement, acceptance: true

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |owner|
      owner.company_name = "ゲストオーナー"
      owner.password = "password"
    end
  end
end
