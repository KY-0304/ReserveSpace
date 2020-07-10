class Owner < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :company_name, presence: true, uniqueness: true
  has_many :rooms, dependent: :destroy
end
