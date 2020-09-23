class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :space

  validates :space_id, presence: true
  validates :user_id,  presence: true , uniqueness: { scope: :space_id }
end
