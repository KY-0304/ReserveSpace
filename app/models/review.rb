class Review < ApplicationRecord
  belongs_to :space
  belongs_to :user

  with_options presence: true do
    validates :rate
    validates :comment
  end

  enum rate: { very_good: 0, good: 1, normal: 2, bad: 3, very_bad: 4 }
end
