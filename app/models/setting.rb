class Setting < ApplicationRecord
  belongs_to :space

  before_update :set_nil_in_start_date_and_end_date, unless: :reservation_unacceptable_mode?

  validates :reservation_unacceptable,    inclusion: { in: [true, false], message: "は不正な値です。" }
  validates :reject_same_day_reservation, inclusion: { in: [true, false], message: "は不正な値です。" }

  with_options if: :reservation_unacceptable_mode? do
    validates_datetime :reservation_unacceptable_end_date, after: :reservation_unacceptable_start_date, allow_nil: true
    validates_datetime :reservation_unacceptable_start_date, on_or_after: :now, allow_nil: true
    validates_datetime :reservation_unacceptable_end_date,   on_or_after: :now, allow_nil: true
  end

  validates :accepted_until_day, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true

  scope :reservation_unacceptable_now, -> { where(reservation_unacceptable: true) }

  scope :reject_same_day_reservation_now, -> { where(reject_same_day_reservation: true) }

  scope :reservation_unacceptable_in_period, -> (start_date, end_date) {
    where("daterange(reservation_unacceptable_start_date, reservation_unacceptable_end_date, '[]') && daterange(?, ?, '[]')", start_date, end_date)
  }

  scope :until_day_greater_than_or_equal, -> (num) { where("accepted_until_day >= ?", num) }

  scope :unset_until_day, -> { where(accepted_until_day: nil) }

  private

  def reservation_unacceptable_mode?
    reservation_unacceptable == true
  end

  def set_nil_in_start_date_and_end_date
    self.reservation_unacceptable_start_date = nil
    self.reservation_unacceptable_end_date = nil
  end
end
