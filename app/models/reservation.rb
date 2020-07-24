class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :start_time, :end_time, overlap: { scope: "room_id", message_title: "既に予約のある時間帯", message_content: "と被っています" }
  validate :within_business_time
  validate :more_one_hour
  validate :by_fifteen_minutes
  validates_datetime :end_time, after: :start_time
  validates_datetime :start_time, on_or_after: :now
  validates_date :end_time, is_at: :start_time

  def reservation_time
    "#{I18n.l(start_time, format: :very_short)}~#{I18n.l(end_time, format: :very_short)}"
  end

  def total_price
    (end_time - start_time).floor / 1.hour * room.hourly_price
  end

  private

  def within_business_time
    room_business_time = [room&.business_start_time, room&.business_end_time]

    validates_time :start_time, between: room_business_time
    validates_time :end_time, between: room_business_time
  end

  def more_one_hour
    validates_time :end_time, on_or_after: start_time&.since(1.hour)
  end

  def by_fifteen_minutes
    errors.add(:start_time, "は15分単位で設定してください") unless start_time&.strftime("%M")&.start_with?(*CHECK_MINUTES)
    errors.add(:end_time, "は15分単位で設定してください") unless end_time&.strftime("%M")&.start_with?(*CHECK_MINUTES)
  end
end
