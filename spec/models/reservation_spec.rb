require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { create(:user) }
  let(:room) { create(:room, business_start_time: "09:00:00", business_end_time: "18:00:00", hourly_price: 1000) }
  let(:reservation) do
    build(:reservation, room: room, user: user, start_time: Time.current.since(1.hour), end_time: Time.current.since(4.hours))
  end

  before { travel_to Time.zone.local(2020, 7, 1, 10) }

  after { travel_back }

  describe "validation" do
    it "有効なファクトリを持つこと" do
      expect(reservation).to be_valid
    end

    it "room_idが無いと無効" do
      reservation.room_id = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "会議室を入力してください"
    end

    it "user_idが無いと無効" do
      reservation.user_id = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "利用者を入力してください"
    end

    it "開始時間が無いと無効" do
      reservation.start_time = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間を入力してください"
    end

    it "終了時間が無いと無効" do
      reservation.end_time = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間を入力してください"
    end

    it "営業時間外だと無効" do
      room.business_start_time = "12:00:00"
      room.business_end_time = "13:00:00"
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間は12:00以降にしてください。"
      expect(reservation.errors.full_messages).to include "終了時間は13:00以前にしてください。"
    end

    it "利用時間が１時間未満だと無効" do
      reservation.start_time = Time.current
      reservation.end_time = Time.current.since(59.minutes)
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間は11:00以降にしてください。"
    end

    it "15分単位の予約時間でないと無効" do
      reservation.start_time = Time.current.since(1.minutes)
      reservation.end_time = Time.current.since(61.minutes)
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間は15分単位で設定してください"
      expect(reservation.errors.full_messages).to include "終了時間は15分単位で設定してください"
    end

    it "終了時間が開始時間より前だと無効" do
      reservation.end_time = Time.current.ago(1.hour)
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間は2020-07-01 11:00より後にしてください。"
    end

    it "開始時間が過去の日時だと無効" do
      reservation.start_time = Time.current.ago(1.hour)
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間は2020-07-01 10:00以降にしてください。"
    end

    it "日付を跨ると無効" do
      reservation.end_time = Time.current.tomorrow
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間は2020-07-01にしてください。"
    end

    context "予約時間帯が被った場合" do
      let(:other_room) { create(:room) }
      let(:other_reservation) { build(:reservation, room: room, start_time: Time.current, end_time: Time.current.since(4.hours)) }

      before do
        travel_to Time.zone.local(2020, 7, 1, 10)
        reservation.save
      end

      after { travel_back }

      it "同じ会議室だと無効" do
        other_reservation.valid?
        expect(other_reservation.errors.full_messages).to include "既に予約のある時間帯と被っています"
      end

      it "違う会議室だと有効" do
        other_reservation.room_id = other_room.id
        expect(other_reservation).to be_valid
      end
    end
  end

  describe "reservation_time" do
    it "「開始時間〜終了時間」を返す" do
      expect(reservation.reservation_time).to eq "11:00~14:00"
    end
  end

  describe "total_price" do
    it "料金単価＊予約時間を返す" do
      expect(reservation.total_price).to eq 3000
    end
  end
end
