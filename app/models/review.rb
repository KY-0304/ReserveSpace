class Review < ApplicationRecord
  belongs_to :space
  belongs_to :user

  with_options presence: true do
    validates :rate
    validates :comment
  end
  validates :comment, length: { maximum: 1000 }
  validate :user_used_space

  enum rate: { very_good: 0, good: 1, normal: 2, bad: 3, very_bad: 4 }

  private

  def user_used_space
    unless Reservation.where(space_id: space_id, user_id: user_id).where("end_time < ?", Time.current).exists?
      errors[:base] << "利用したことの無いスペースにレビューを投稿することはできません。"
    end
  end
end
