class Room < ApplicationRecord
  belongs_to :owner
  validates :name, presence: true
  validates :address, presence: true
  validates :hourly_price, presence: true
  validates :business_start_time, presence: true
  validates :business_end_time, presence: true

  mount_uploader :image, ImageUploader
end
