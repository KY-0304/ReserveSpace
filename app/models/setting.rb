class Setting < ApplicationRecord
  belongs_to :space

  # 予約受付拒否の終了日時が開始日時の後になっていることを検証する
  validates_datetime :unacceptable_end_time, after: :unacceptable_start_time, if: Proc.new { |s| s.unacceptable? }
  # 予約受付拒否の開始日時が現在以降になっていることを検証する
  validates_datetime :unacceptable_start_time, on_or_after: :now, if: Proc.new { |s| s.unacceptable? }
end
