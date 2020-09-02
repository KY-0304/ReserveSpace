class Setting < ApplicationRecord
  belongs_to :space

  after_validation :set_nil_in_limit_day, unless: :reservation_limit_day_mode?

  validates :reservation_unacceptable,    inclusion: { in: [true, false], message: "は不正な値です。" }
  validates :reject_same_day_reservation, inclusion: { in: [true, false], message: "は不正な値です。" }
  validates :reservation_limit_day,       inclusion: { in: [true, false], message: "は不正な値です。" }

  with_options if: :reservation_unacceptable_mode? do
    validates_datetime :reservation_unacceptable_end_date, after: :reservation_unacceptable_start_date, allow_nil: true
    validates_datetime :reservation_unacceptable_start_date, on_or_after: :now, allow_nil: true
    validates_datetime :reservation_unacceptable_end_date,   on_or_after: :now, allow_nil: true
  end

  with_options if: :reservation_limit_day_mode? do
    validates :limit_day, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end

  scope :reservation_unacceptable_now, -> {
    where(reservation_unacceptable: true)
  }

  scope :reject_same_day_reservation_now, -> {
    where(reject_same_day_reservation: true)
  }

  scope :reservation_unacceptable_in_period, -> (start_date, end_date) {
    where("daterange(reservation_unacceptable_start_date, reservation_unacceptable_end_date, '[]') && daterange(?, ?, '[]')", start_date, end_date)
  }

  private

  def reservation_unacceptable_mode?
    reservation_unacceptable == true
  end

  def reservation_limit_day_mode?
    reservation_limit_day == true
  end

  def set_nil_in_limit_day
    limit_day = nil
  end
end
