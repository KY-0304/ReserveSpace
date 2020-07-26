class Reservation < ApplicationRecord
  belongs_to :space
  belongs_to :user

  with_options presence: true do
    validates :start_time
    validates :end_time
  end
  # 同じスペース内で開始時間と終了時間の間に他の予約があるか検証する
  validates :start_time, :end_time, overlap: { scope: :space_id, message_title: "既に予約のある時間帯", message_content: "と被っています" }
  # 開始時間より後に終了時間があるか検証する
  validates_datetime :end_time, after: :start_time
  # 開始時間が現在時刻以降になっていることを検証する
  validates_datetime :start_time, on_or_after: :now
  # 終了時間の日付が開始時間の日付と一致していることを検証する
  validates_date :end_time, is_at: :start_time
  # スペースの営業時間内に予約時間が収まっていることを検証する
  validate :within_business_time
  # 最低でも1時間以上の予約であることを検証する
  validate :more_one_hour
  # 開始時間、終了時間が15分単位であることを検証する
  validate :by_fifteen_minutes

  # 予約時間をわかりやすく表示する
  def reservation_time
    "#{I18n.l(start_time, format: :very_short)}~#{I18n.l(end_time, format: :very_short)}"
  end

  # スペースの単価と予約時間数を掛けて合計金額を計算する
  def total_price
    (end_time - start_time).floor / 1.hour * space.hourly_price
  end

  private

  def within_business_time
    space_business_time = [space&.business_start_time, space&.business_end_time]

    validates_time :start_time, between: space_business_time
    validates_time :end_time, between: space_business_time
  end

  def more_one_hour
    validates_time :end_time, on_or_after: start_time&.since(1.hour)
  end

  def by_fifteen_minutes
    errors.add(:start_time, "は15分単位で設定してください") unless start_time&.strftime("%M")&.start_with?(*CHECK_MINUTES)
    errors.add(:end_time, "は15分単位で設定してください") unless end_time&.strftime("%M")&.start_with?(*CHECK_MINUTES)
  end
end
