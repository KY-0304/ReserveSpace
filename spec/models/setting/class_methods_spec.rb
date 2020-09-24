require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe "class_methods" do
    describe "reservation_unacceptable_now" do
      let!(:setting1) { create(:setting, :skip_validate, reservation_unacceptable: true) }
      let!(:setting2) { create(:setting, :skip_validate, reservation_unacceptable: false) }

      it "reservation_unacceptableがtrueのsettingを返す" do
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

    describe "reject_same_day_reservation_now" do
      let!(:setting1) { create(:setting, :skip_validate, reject_same_day_reservation: true) }
      let!(:setting2) { create(:setting, :skip_validate, reject_same_day_reservation: false) }

      it "reject_same_day_reservationがtrueの設定を返す" do
        expect(Setting.reject_same_day_reservation_now).to match_array [setting1]
      end
    end

    describe "until_day_greater_than_or_equal(num)" do
      let!(:setting1) { create(:setting, :skip_validate, accepted_until_day: 11) }
      let!(:setting2) { create(:setting, :skip_validate, accepted_until_day: 10) }
      let!(:setting3) { create(:setting, :skip_validate, accepted_until_day: 9) }

      it "引数以上のaccepted_until_dayを持つ設定を返す" do
        expect(Setting.until_day_greater_than_or_equal(10)).to match_array [setting1, setting2]
      end
    end

    describe "unset_until_day" do
      let!(:setting1) { create(:setting, :skip_validate, accepted_until_day: nil) }
      let!(:setting2) { create(:setting, :skip_validate, accepted_until_day: 10) }

      it "accepted_until_dayがnilの設定を返す" do
        expect(Setting.unset_until_day).to match_array [setting1]
      end
    end
  end
end
