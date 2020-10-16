# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :text             not null
#  rate       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  space_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_reviews_on_space_id  (space_id)
#  index_reviews_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (space_id => spaces.id)
#  fk_rails_...  (user_id => users.id)
#
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
