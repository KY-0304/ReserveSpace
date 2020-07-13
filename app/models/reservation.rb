class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :start_time, :end_time, overlap: { scope: "room_id", message_title: "既に予約のある時間帯", message_content: "と被っています" }
  validate :within_business_time
  validate :more_one_hour
  validate :fifteen_minutes_increment
  validates_datetime :end_time, after: :start_time
  validates_datetime :start_time, on_or_after: :now
  validates_date :end_time, is_at: :start_time

  private

  def within_business_time
    return unless room

    validates_time :start_time, between: [room.business_start_time, room.business_end_time]
    validates_time :end_time, between: [room.business_start_time, room.business_end_time]
  end

  def more_one_hour
    return unless start_time

    validates_time :end_time, on_or_after: start_time.since(1.hour)
  end

  def fifteen_minutes_increment
    return if !(start_time && end_time)

    start_time_remainder = (start_time.strftime("%M").to_i * 1.minutes) % 15.minutes
    end_time_remainder = (end_time.strftime("%M").to_i * 1.minutes) % 15.minutes

    errors.add(:start_time, "は15分単位で設定してください") unless start_time_remainder.zero?
    errors.add(:end_time, "は15分単位で設定してください") unless end_time_remainder.zero?
  end
end
