class Review < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :rate, presence: true, numericality: { less_than_or_equal_to: 5, greater_than: 0 }
  validates :comment, length: { maximum: 100 }
end
