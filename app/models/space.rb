# == Schema Information
#
# Table name: spaces
#
#  id                  :bigint           not null, primary key
#  address_building    :string
#  address_city        :string           not null
#  address_street      :string           not null
#  business_end_time   :time             not null
#  business_start_time :time             not null
#  capacity            :integer          not null
#  description         :text
#  hourly_price        :integer          not null
#  images              :jsonb
#  impressions_count   :integer          default(0)
#  latitude            :float
#  longitude           :float
#  name                :string           not null
#  phone_number        :string           not null
#  postcode            :integer          not null
#  prefecture_code     :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :bigint           not null
#
# Indexes
#
#  index_spaces_on_address_building     (address_building)
#  index_spaces_on_address_city         (address_city)
#  index_spaces_on_address_street       (address_street)
#  index_spaces_on_business_end_time    (business_end_time)
#  index_spaces_on_business_start_time  (business_start_time)
#  index_spaces_on_hourly_price         (hourly_price)
#  index_spaces_on_owner_id             (owner_id)
#  index_spaces_on_postcode             (postcode)
#  index_spaces_on_prefecture_code      (prefecture_code)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
class Space < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code

  mount_uploaders :images, ImageUploader

  is_impressionable counter_cache: true

  geocoded_by :geocode_address

  after_validation :geocode
  after_create :setting_create
  before_destroy :check_all_reservations_finished

  belongs_to :owner
  has_one  :setting,      dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :reviews,      dependent: :destroy
  has_many :favorites,    dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  with_options presence: true do
    validates :name,           length: { maximum: MAX_SPACE_NAME_LENGTH }
    validates :address_city,   length: { maximum: MAX_ADDRESS_CITY_LENGTH }
    validates :address_street, length: { maximum: MAX_ADDRESS_STREET_LENGTH }
    validates :phone_number,   format: { with: VALID_PHONE_NUMBER_REGEX }
    validates :hourly_price,   numericality: { only_integer: true, greater_than_or_equal_to: MINIMUM_UNIT_SPACE_PRICE }
    validates :capacity,       numericality: { only_integer: true }
    validates :postcode
    validates :prefecture_code
    validates :business_start_time
    validates :business_end_time
  end

  validates :description,      length: { maximum: MAX_SPACE_DESCRIPTION_LENGTH }
  validates :address_building, length: { maximum: MAX_ADDRESS_BUILDING_LENGTH }

  validates_time :business_end_time, after: :business_start_time

  validate :divide_by_one_hundred

  delegate :reservation_unacceptable,
           :reservation_unacceptable=,
           :reservation_unacceptable_start_date,
           :reservation_unacceptable_start_date=,
           :reservation_unacceptable_end_date,
           :reservation_unacceptable_end_date=,
           :reject_same_day_reservation,
           :reject_same_day_reservation=,
           :accepted_until_day,
           :accepted_until_day=,
           to: :setting

  scope :users_search, -> (search_params) {
    return unless search_params

    if search_params[:start_datetime].present? && search_params[:times].present?
      start_datetime = search_params[:start_datetime].in_time_zone
      end_datetime   = start_datetime + search_params[:times].to_i.hours
    end

    include_address_search_keyword(search_params[:address_keyword]).
      match_prefecture_code(search_params[:prefecture_code]).
      hourly_price_less_than_or_equal(search_params[:hourly_price]).
      capacity_more_than_or_equal(search_params[:capacity]).
      does_not_have_reservations_in_time_range(start_datetime, end_datetime).
      reservation_acceptable_in_period(start_datetime, end_datetime).
      reservation_acceptable_in_same_day(start_datetime).
      reservation_acceptable_within_until_day(start_datetime)
  }

  scope :hourly_price_less_than_or_equal, -> (price) { where("hourly_price <= ?", price) if price.present? }

  scope :capacity_more_than_or_equal, -> (capacity) { where("capacity >= ?", capacity) if capacity.present? }

  scope :match_prefecture_code, -> (prefecture_code) { where(prefecture_code: prefecture_code) if prefecture_code.present? }

  scope :include_address_search_keyword, -> (keyword) {
    where("CONCAT(address_city, address_street, address_building) LIKE ?", "%#{keyword}%") if keyword.present?
  }

  scope :does_not_have_reservations_in_time_range, -> (start_time, end_time) {
    if start_time.present? && end_time.present?
      space_ids = Reservation.duplication_in_datetime_range(start_time, end_time).pluck(:space_id)
      where.not(id: space_ids)
    end
  }

  scope :reservation_acceptable_in_period, -> (start_date, end_date) {
    if start_date.present? && end_date.present?
      space_ids = Setting.reservation_unacceptable_now.reservation_unacceptable_in_period(start_date, end_date).pluck(:space_id)
      where.not(id: space_ids)
    end
  }

  scope :reservation_acceptable_in_same_day, -> (date) {
    return if date.blank?

    if date.to_date == Date.current
      space_ids = Setting.reject_same_day_reservation_now.pluck(:space_id)
      where.not(id: space_ids)
    end
  }

  scope :reservation_acceptable_within_until_day, -> (date) {
    if date.present?
      days      = date.to_date - Date.current
      space_ids = Setting.until_day_greater_than_or_equal(days.to_i).or(Setting.unset_until_day).pluck(:space_id)
      where(id: space_ids)
    end
  }

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def full_address
    address_array.join
  end

  def business_time
    "#{I18n.l(business_start_time, format: :very_short)} 〜 #{I18n.l(business_end_time, format: :very_short)}"
  end

  private

  def divide_by_one_hundred
    return unless hourly_price

    unless hourly_price % 100 == 0
      errors.add(:hourly_price, "は100円単位で設定してください")
    end
  end

  def address_array
    [prefecture_name, address_city, address_street, address_building].compact
  end

  def geocode_address
    address_array.join(', ')
  end

  def check_all_reservations_finished
    errors[:base] << "予約があるスペースは削除できません。" if reservations.unfinished.exists?

    throw(:abort) unless errors.empty?
  end

  def setting_create
    create_setting!
  end
end
