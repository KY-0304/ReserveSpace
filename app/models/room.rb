class Room < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code
  has_many :reservations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :reviews
  belongs_to :owner
  validates :name, presence: true
  validates :image, presence: true
  validates :postcode, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :hourly_price, presence: true
  validates :business_start_time, presence: true
  validates :business_end_time, presence: true
  validate :image_size
  validate :price_negative
  validate :not_same_time
  validate :onehundred_yen_break
  geocoded_by :address
  after_validation :geocode

  mount_uploader :image, ImageUploader

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def full_address
    [prefecture_name, address_city, address_street, address_building].compact.join
  end

  def address
    [prefecture_name, address_city, address_street, address_building].compact.join(', ')
  end

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

  def onehundred_yen_break
    return unless hourly_price

    hourly_price_remainder = hourly_price % MINIMUM_UNIT_ROOM_PRICE
    errors.add(:hourly_price, "は100円単位で設定してください") unless hourly_price_remainder.zero?
  end
end
