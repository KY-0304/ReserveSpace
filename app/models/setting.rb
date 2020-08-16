class Setting < ApplicationRecord
  belongs_to :space

  validates :date_range_reservation_unacceptable, inclusion: { in: [true, false], message: "は不正な値です。" }

  with_options if: :date_range_mode? do
    # 予約受付拒否の終了日時が開始日時の後になっていることを検証する
    validates_datetime :reservation_unacceptable_end_day, after: :reservation_unacceptable_start_day
    # 予約受付拒否の開始日時が現在以降になっていることを検証する
    validates_datetime :reservation_unacceptable_start_day, on_or_after: :now
  end

  private

  def date_range_mode?
    date_range_reservation_unacceptable == true
  end
end
