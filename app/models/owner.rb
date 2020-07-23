class Owner < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rooms, dependent: :destroy

  validates :company_name, presence: true, uniqueness: true
  validates :agreement, acceptance: true
end
