class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :room_id }
  validates :room_id, presence: true
end
