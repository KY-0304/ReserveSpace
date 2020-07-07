class Room < ApplicationRecord
  belongs_to :owner
  validates :name, presence: true
  validates :image, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :hourly_price, presence: true
  validates :business_start_time, presence: true
  validates :business_end_time, presence: true
  validate :image_size
  validate :price_negative
  validate :not_same_time

  mount_uploader :image, ImageUploader

  private

  def image_size
    errors.add(:image, "は5MB以下にしてください") if image.size > 5.megabytes
  end

  def price_negative
    errors.add(:hourly_price, "は負の値を指定できません") if hourly_price.to_i.negative?
  end

  def not_same_time
    errors.add(:business_end_time, "は営業開始時間と同じ値を指定できません") if business_start_time == business_end_time
  end
end
