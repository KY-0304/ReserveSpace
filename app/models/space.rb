class Space < ApplicationRecord
  after_create :setting_create
  before_destroy :check_all_reservations_finished
  # jp_prefectureの都道府県コードを使用する
  include JpPrefecture
  jp_prefecture :prefecture_code

  belongs_to :owner
  has_one  :setting,      dependent: :destroy
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
    validates :capacity,       numericality: { only_integer: true }
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

  delegate :reservation_unacceptable,
           :reservation_unacceptable=,
           :reservation_unacceptable_start_date,
           :reservation_unacceptable_start_date=,
           :reservation_unacceptable_end_date,
           :reservation_unacceptable_end_date=,
           :reject_same_day_reservation,
           :reject_same_day_reservation=,
           to: :setting

  scope :users_search, -> (search_params) {
    return unless search_params

    if search_params[:start_datetime].present? && search_params[:times].present?
      start_datetime = search_params[:start_datetime].in_time_zone
      end_datetime = start_datetime + search_params[:times].to_i.hours
    end

    include_address_search_keyword(search_params[:address_keyword]).
      match_prefecture_code(search_params[:prefecture_code]).
      hourly_price_less_than_or_equal(search_params[:hourly_price]).
      capacity_more_than_or_equal(search_params[:capacity]).
      does_not_have_reservations_in_time_range(start_datetime, end_datetime).
      reservation_acceptable_in_period(start_datetime, end_datetime)
  }

  scope :hourly_price_less_than_or_equal, -> (price) {
    where("hourly_price <= ?", price) if price.present?
  }

  scope :capacity_more_than_or_equal, -> (capacity) {
    where("capacity >= ?", capacity) if capacity.present?
  }

  # 市区町村、番地、建物を結合したものの中からキーワードを含むスペースを返す
  scope :include_address_search_keyword, -> (keyword) {
    where("CONCAT(address_city, address_street, address_building) LIKE ?", "%#{keyword}%") if keyword.present?
  }

  scope :match_prefecture_code, -> (prefecture_code) {
    where(prefecture_code: prefecture_code) if prefecture_code.present?
  }

  # 与えられた日時に予約が無いスペースを返す
  scope :does_not_have_reservations_in_time_range, -> (start_time, end_time) {
    if start_time.present? && end_time.present?
      ids = Reservation.duplication_in_time_range(start_time, end_time).pluck(:space_id)
      where.not(id: ids)
    end
  }

  scope :reservation_acceptable_in_period, -> (start_date, end_date) {
    if start_date.present? && end_date.present?
      ids = Setting.reservation_unacceptable_now.reservation_unacceptable_in_period(start_date, end_date).pluck(:space_id)
      where.not(id: ids)
    end
  }

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

  # 営業時間を開始時間 〜 終了時間の形で表示する
  def business_time
    "#{I18n.l(business_start_time, format: :very_short)} 〜 #{I18n.l(business_end_time, format: :very_short)}"
  end

  private

  # geocoderで緯度、経度を計算する為のメソッド
  def geocode_address
    [prefecture_name, address_city, address_street, address_building].compact.join(', ')
  end

  def check_all_reservations_finished
    if reservations.where("start_time > ?", Time.current).exists?
      errors[:base] << "予約があるスペースは、削除できません。"
    end

    throw(:abort) unless errors.empty?
  end

  def setting_create
    create_setting!
  end
end
