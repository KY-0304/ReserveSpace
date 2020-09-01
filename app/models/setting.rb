class Setting < ApplicationRecord
  belongs_to :space

  validates :reservation_unacceptable,    inclusion: { in: [true, false], message: "は不正な値です。" }
  validates :reject_same_day_reservation, inclusion: { in: [true, false], message: "は不正な値です。" }

  with_options if: :reservation_unacceptable_mode? do
    validates_datetime :reservation_unacceptable_end_date, after: :reservation_unacceptable_start_date, allow_nil: true
    validates_datetime :reservation_unacceptable_start_date, on_or_after: :now, allow_nil: true
    validates_datetime :reservation_unacceptable_end_date,   on_or_after: :now, allow_nil: true
  end

  scope :reservation_unacceptable_now, -> {
    where(reservation_unacceptable: true)
  }

  scope :reservation_unacceptable_in_period, -> (start_date, end_date) {
    where("daterange(reservation_unacceptable_start_date, reservation_unacceptable_end_date, '[]') && daterange(?, ?, '[]')", start_date, end_date)
  }

  private

  def reservation_unacceptable_mode?
    reservation_unacceptable == true
  end
end
