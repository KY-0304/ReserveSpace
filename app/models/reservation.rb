class Reservation < ApplicationRecord
  belongs_to :space
  belongs_to :user

  with_options presence: true do
    validates :start_time
    validates :end_time
  end

  validates :start_time, :end_time, overlap: { scope: :space_id, message_title: "予約重複：", message_content: "既にある予約と被っています。" }

  validates_datetime :end_time, after: :start_time
  validates_datetime :start_time, on_or_after: :now

  validate :within_space_business_time
  validate :more_one_hour
  validate :by_fifteen_minutes
  validate :same_day_or_next_day
  validate :reservation_acceptable_in_date, if: :reservation_unacceptable_mode?
  validate :reservation_acceptable_in_same_day, if: :reject_same_day_reservation_mode?
  validate :within_acceptable_date

  scope :owners_search, -> (search_params) {
    return unless search_params

    start_datetime = search_params[:start_datetime].in_time_zone if search_params[:start_datetime].present?
    end_datetime   = search_params[:end_datetime].in_time_zone   if search_params[:end_datetime].present?

    duplication_in_datetime_range(start_datetime, end_datetime)
  }

  scope :duplication_in_datetime_range, -> (start_datetime, end_datetime) {
    where("tstzrange(start_time, end_time, '[]') && tstzrange(?, ?, '[]')", start_datetime, end_datetime)
  }

  scope :for_the_day, -> (date) {
    beginning_of_day = date.beginning_of_day
    end_of_day       = date.end_of_day

    where(start_time: beginning_of_day..end_of_day)
  }

  scope :finished, -> { where("end_time < ?", Time.current) }

  scope :unfinished, -> { where("end_time >= ?", Time.current) }

  def reservation_time
    "#{I18n.l(start_time, format: :very_short)}~#{I18n.l(end_time, format: :very_short)}"
  end

  def total_price
    (hours_of_use * space.hourly_price).floor
  end

  def hours_of_use
    (end_time - start_time) / 1.hour
  end

  def owners_sales_amount
    total_price - reserve_space_sales_amount
  end

  def reserve_space_sales_amount
    total_price * RESERVE_SPACE_FEE / 100
  end

  def cancelable?
    start_time.to_date > Date.current
  end

  private

  def within_space_business_time
    return unless space

    space_business_time = [space.business_start_time, space.business_end_time]

    validates_time :start_time, between: space_business_time
    validates_time :end_time,   between: space_business_time
  end

  def more_one_hour
    return unless start_time

    validates_time :end_time, on_or_after: start_time + 1.hour
  end

  def by_fifteen_minutes
    return unless start_time && end_time

    minutes_of_start_time = start_time.strftime("%M")
    minutes_of_end_time   = end_time.strftime("%M")

    errors.add(:start_time, "は15分単位で設定してください") unless minutes_of_start_time.start_with?(*CHECK_MINUTES)
    errors.add(:end_time,   "は15分単位で設定してください") unless minutes_of_end_time.start_with?(*CHECK_MINUTES)
  end

  def same_day_or_next_day
    return unless start_time && end_time

    start_date = start_time.to_date
    end_date   = end_time.to_date

    unless start_date == end_date || start_date + 1.day == end_date
      errors.add(:end_time, "は、開始日時と同じ日付、もしくは翌日にしてください。")
    end
  end

  def reservation_unacceptable_mode?
    space&.reservation_unacceptable == true
  end

  def reservation_acceptable_in_date
    reservation_date                    = start_time.to_date
    reservation_unacceptable_start_date = space.reservation_unacceptable_start_date
    reservation_unacceptable_end_date   = space.reservation_unacceptable_end_date

    if reservation_unacceptable_start_date && reservation_unacceptable_end_date
      if (reservation_unacceptable_start_date <= reservation_date) && (reservation_date <= reservation_unacceptable_end_date)
        errors[:base] << "現在、#{reservation_unacceptable_start_date}から#{reservation_unacceptable_end_date}の期間は予約を受け付けておりません。"
      end
    elsif reservation_unacceptable_start_date
      if reservation_unacceptable_start_date <= reservation_date
        errors[:base] << "現在、#{reservation_unacceptable_start_date}以降の予約を受け付けておりません。"
      end
    elsif reservation_unacceptable_end_date
      if reservation_unacceptable_end_date >= reservation_date
        errors[:base] << "現在、#{reservation_unacceptable_end_date}以前の予約を受け付けておりません。"
      end
    else
      errors[:base] << "現在、新規の予約を受け付けておりません。"
    end
  end

  def reject_same_day_reservation_mode?
    space&.reject_same_day_reservation == true
  end

  def reservation_acceptable_in_same_day
    if start_time.to_date == Date.current
      errors[:base] << "当日の予約は受付できません。"
    end
  end

  def within_acceptable_date
    return if space&.accepted_until_day.nil?

    reservation_date    = start_time.to_date
    max_acceptable_date = Date.current + space.accepted_until_day.days

    if reservation_date > max_acceptable_date
      errors[:base] << "#{max_acceptable_date}より後の予約は受け付けられません。"
    end
  end
end
