class Review < ApplicationRecord
  belongs_to :space
  belongs_to :user

  with_options presence: true do
    validates :rate
    validates :comment
  end

  validates :comment, length: { maximum: MAX_COMMENT_LENGTH }

  validate :user_used_space

  enum rate: { very_good: 0, good: 1, normal: 2, bad: 3, very_bad: 4 }

  private

  def user_used_space
    unless Reservation.where(space_id: space_id, user_id: user_id).finished.exists?
      errors[:base] << "利用したことの無いスペースにレビューを投稿することはできません。"
    end
  end
end
