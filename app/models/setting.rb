class Setting < ApplicationRecord
  belongs_to :space

  validates :reservation_unacceptable, inclusion: { in: [true, false], message: "は不正な値です。" }

  with_options if: :reservation_unacceptable_mode? do
    validates_datetime :reservation_unacceptable_end_date, after: :reservation_unacceptable_start_date, allow_nil: true
    validates_datetime :reservation_unacceptable_start_date, on_or_after: :now, allow_nil: true
    validates_datetime :reservation_unacceptable_end_date,   on_or_after: :now, allow_nil: true
  end

  private

  def reservation_unacceptable_mode?
    reservation_unacceptable == true
  end
end
