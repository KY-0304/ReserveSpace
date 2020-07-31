class Space < ApplicationRecord
  # jp_prefectureの都道府県コードを使用する
  include JpPrefecture
  jp_prefecture :prefecture_code

  belongs_to :owner
  has_many :reservations, dependent: :destroy
  has_many :reviews,      dependent: :destroy
  has_many :favorites,    dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  with_options presence: true do
    validates :name,           length: { maximum: 100 }
    validates :address_city,   length: { maximum: 20 }
    validates :address_street, length: { maximum: 30 }
    validates :phone_number,   format: { with: VALID_PHONE_NUMBER_REGEX }
    validates :hourly_price,   format: { with: VALID_HOURLY_PRICE_REGEX, message: "は100円単位で設定してください" },
                               numericality: { only_integer: true, greater_than_or_equal_to: MINIMUM_UNIT_ROOM_PRICE }
    validates :postcode
    validates :prefecture_code
    validates :business_start_time
    validates :business_end_time
  end

  validates :description,      length: { maximum: 3000 }
  validates :address_building, length: { maximum: 50 }

  # 営業終了時間が営業開始時間より後になっていることを検証する
  validates_time :business_end_time, after: :business_start_time

  # googlemap用に緯度、経度を計算して保存する
  geocoded_by :geocode_address
  after_validation :geocode

  mount_uploaders :images, ImageUploader

  # 都道府県名のゲッターメソッド
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  # 都道府県名のセッターメソッド
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  # 都道府県、市区町村、番地、建物を繋げて表示する
  def full_address
    [prefecture_name, address_city, address_street, address_building].compact.join
  end

  # 営業時間をわかりやすく表示する
  def business_time
    "#{I18n.l(business_start_time, format: :very_short)} 〜 #{I18n.l(business_end_time, format: :very_short)}"
  end

  private

  # geocoderで緯度、経度を計算する為のメソッド
  def geocode_address
    [prefecture_name, address_city, address_street, address_building].compact.join(', ')
  end
end
