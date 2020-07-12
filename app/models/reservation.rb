class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_time, presence: true, uniqueness: true
  validates :end_time, presence: true, uniqueness: true
end
