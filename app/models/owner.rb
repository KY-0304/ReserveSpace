class Owner < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :spaces, dependent: :destroy

  validates :email, length: { maximum: 255 }
  validates :company_name, presence: true, uniqueness: true, length: { maximum: 140 }
  validates :agreement, acceptance: true
end
