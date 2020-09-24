require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe "validation" do
    let(:start_day) { Date.parse("2000/1/1") }
    let(:end_day)   { Date.parse("2000/1/2") }
    let(:setting) do
      create(:setting, reservation_unacceptable: true,
                       reservation_unacceptable_start_date: start_day,
                       reservation_unacceptable_end_date: end_day)
    end

    before { travel_to Time.zone.local(2000, 1, 1) }

    after { travel_back }

    it "有効なファクトリを持つこと" do
      expect(setting).to be_valid
    end

    it "reservation_unacceptableがnilだと無効" do
      setting.reservation_unacceptable = nil
      setting.valid?
      expect(setting.errors.full_messages).to include "予約受付不可は不正な値です。"
    end

    context "reservation_unacceptableがtrueの場合" do
      before do
        setting.reservation_unacceptable = true
      end

      it "reservation_unacceptable_end_dateがreservation_unacceptable_start_dateより前だと無効" do
        setting.reservation_unacceptable_start_date = end_day
        setting.reservation_unacceptable_end_date   = start_day
        setting.valid?
        expect(setting.errors.full_messages).to include "予約不可終了日は2000-01-02 00:00より後にしてください。"
      end

      it "reservation_unacceptable_start_dateが現在より前の日だと無効" do
        setting.reservation_unacceptable_start_date = Date.parse("1999/12/31")
        setting.valid?
        expect(setting.errors.full_messages).to include "予約不可開始日は2000-01-01 00:00以降にしてください。"
      end

      it "reservation_unacceptable_end_dateが現在より前の日だと無効" do
        setting.reservation_unacceptable_end_date = Date.parse("1999/12/31")
        setting.valid?
        expect(setting.errors.full_messages).to include "予約不可終了日は2000-01-01 00:00以降にしてください。"
      end

      it "reservation_unacceptable_start_date、reservation_unacceptable_end_dateはnilでも有効" do
        setting.reservation_unacceptable_start_date = nil
        setting.reservation_unacceptable_end_date   = nil
        expect(setting).to be_valid
      end
    end

    it "reject_same_day_reservationがnilだと無効" do
      setting.reject_same_day_reservation = nil
      setting.valid?
      expect(setting.errors.full_messages).to include "当日予約不可は不正な値です。"
    end

    it "accepted_until_dayが整数以外だと無効" do
      setting.accepted_until_day = 1.1
      setting.valid?
      expect(setting.errors.full_messages).to include "予約受付可能日数は整数で入力してください"
    end

    it "accepted_until_dayが1未満だと無効" do
      setting.accepted_until_day = -1
      setting.valid?
      expect(setting.errors.full_messages).to include "予約受付可能日数は1以上の値にしてください"
    end
  end
end
