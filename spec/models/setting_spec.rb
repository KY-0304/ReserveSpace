require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe "validation" do
    let(:start_day) { Date.parse("2000/1/1") }
    let(:end_day)   { Date.parse("2000/1/2") }
    let(:setting) do
      build(:setting, reservation_unacceptable: true,
                      reservation_unacceptable_start_date: start_day,
                      reservation_unacceptable_end_date: end_day)
    end

    before { travel_to Time.zone.local(2000, 1, 1) }

    after { travel_back }

    it "有効なファクトリを持つこと" do
      expect(setting).to be_valid
    end

    it "予約受付拒否(日付範囲)がnilだと無効" do
      setting.reservation_unacceptable = nil
      setting.valid?
      expect(setting.errors.full_messages).to include "予約受付不可は不正な値です。"
    end

    context "予約受付拒否(日付範囲)がtrueの場合" do
      before do
        setting.reservation_unacceptable = true
      end

      it "予約受付拒否終了日が開始日より前だと無効" do
        setting.reservation_unacceptable_start_date = end_day
        setting.reservation_unacceptable_end_date   = start_day
        setting.valid?
        expect(setting.errors.full_messages).to include "予約不可終了日は2000-01-02 00:00より後にしてください。"
      end

      it "予約受付拒否開始日時が現在より前の日時だと無効" do
        setting.reservation_unacceptable_start_date = Date.parse("1999/12/31")
        setting.valid?
        expect(setting.errors.full_messages).to include "予約不可開始日は2000-01-01 00:00以降にしてください。"
      end

      it "予約受付拒否終了日時が現在より前の日時だと無効" do
        setting.reservation_unacceptable_end_date = Date.parse("1999/12/31")
        setting.valid?
        expect(setting.errors.full_messages).to include "予約不可終了日は2000-01-01 00:00以降にしてください。"
      end

      it "予約受付拒否開始日、終了日はnilでも有効" do
        setting.reservation_unacceptable_start_date = nil
        setting.reservation_unacceptable_end_date   = nil
        expect(setting).to be_valid
      end
    end

    context "予約受付拒否(日付範囲)がfalseの場合" do
      before do
        setting.reservation_unacceptable = false
      end

      it "予約受付拒否開始日と終了日に関わるバリデーションをしない" do
        setting.reservation_unacceptable_start_date = end_day
        setting.reservation_unacceptable_end_date   = start_day
        expect(setting).to be_valid
      end
    end
  end

  describe "class_methods" do
    describe "reservation_unacceptable_now" do
      let!(:setting1) { create(:setting, :skip_validate, reservation_unacceptable: true) }
      let!(:setting2) { create(:setting, :skip_validate, reservation_unacceptable: false) }

      it "予約不可の設定をしているsettingを返す" do
        expect(Setting.reservation_unacceptable_now).to match_array [setting1]
      end
    end

    describe "reservation_unacceptable_in_period" do
      let!(:setting1) do
        create(:setting, :skip_validate, reservation_unacceptable_start_date: Date.parse("2000/1/1"),
                                         reservation_unacceptable_end_date: Date.parse("2000/1/10"))
      end
      let!(:setting2) do
        create(:setting, :skip_validate, reservation_unacceptable_start_date: Date.parse("2000/1/11"),
                                         reservation_unacceptable_end_date: Date.parse("2000/1/19"))
      end
      let!(:setting3) do
        create(:setting, :skip_validate, reservation_unacceptable_start_date: Date.parse("2000/1/20"),
                                         reservation_unacceptable_end_date: Date.parse("2000/1/30"))
      end

      context "start_date, end_dateを渡した場合" do
        it "引数の期間中に予約不可日を設けているsettingを返す" do
          start_date = Date.parse("2000/1/10")
          end_date   = Date.parse("2000/1/20")
          expect(Setting.reservation_unacceptable_in_period(start_date, end_date)).to match_array [setting1, setting2, setting3]
        end
      end

      context "start_dateのみを渡した場合" do
        it "start_date以降に予約不可日を設けているsettingを返す" do
          start_date = Date.parse("2000/1/11")
          end_date   = nil
          expect(Setting.reservation_unacceptable_in_period(start_date, end_date)).to match_array [setting2, setting3]
        end
      end

      context "end_dateのみを渡した場合" do
        it "end_date以前に予約不可日を設けているsettingを返す" do
          start_date = nil
          end_date   = Date.parse("2000/1/19")
          expect(Setting.reservation_unacceptable_in_period(start_date, end_date)).to match_array [setting1, setting2]
        end
      end

      context "start_date, end_date共にnilを渡した場合" do
        it "全てのsettingを返す" do
          start_date = nil
          end_date   = nil
          expect(Setting.reservation_unacceptable_in_period(start_date, end_date)).to match_array Setting.all
        end
      end
    end
  end
end
