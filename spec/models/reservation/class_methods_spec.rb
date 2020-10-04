require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "class_methods" do
    describe "owners_search" do
      let!(:reservations) { create_list(:reservation, 5, :skip_validate) }

      context "パラメータがblankだった場合" do
        let(:params) { { start_datetime: "", end_datetime: "" } }

        it "すべての予約を返す" do
          expect(Reservation.owners_search(params)).to match_array Reservation.all
        end
      end

      context "パラメータがnilだった場合" do
        let(:params) { nil }

        it "すべての予約を返す" do
          expect(Reservation.owners_search(params)).to match_array Reservation.all
        end
      end
    end

    describe "duplication_in_datetime_range" do
      let!(:reservation1) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 09:00:00".in_time_zone,
                                             end_time: "2000-01-01 12:00:00".in_time_zone)
      end
      let!(:reservation2) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 13:00:00".in_time_zone,
                                             end_time: "2000-01-01 15:00:00".in_time_zone)
      end

      it "予約時間帯が引数の時間帯と重複している予約を返す" do
        times = []
        24.times { |i| times << "2000-01-01 #{i}:00:00".in_time_zone }

        expect(Reservation.duplication_in_datetime_range(times[9], times[12])).to match_array [reservation1]
        expect(Reservation.duplication_in_datetime_range(times[9], times[13])).to match_array [reservation1, reservation2]
        expect(Reservation.duplication_in_datetime_range(times[9], times[15])).to match_array [reservation1, reservation2]
        expect(Reservation.duplication_in_datetime_range(times[11], times[14])).to match_array [reservation1, reservation2]
        expect(Reservation.duplication_in_datetime_range(times[8], times[16])).to match_array [reservation1, reservation2]
      end
    end

    describe "for_the_day(date)" do
      let!(:reservation1) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 00:00:00".in_time_zone,
                                             end_time: "2000-01-01 23:59:59".in_time_zone)
      end
      let!(:reservation2) do
        create(:reservation, :skip_validate, start_time: "2000-01-02 00:00:00".in_time_zone,
                                             end_time: "2000-01-02 23:59:59".in_time_zone)
      end
      let!(:reservation3) do
        create(:reservation, :skip_validate, start_time: "2000-01-03 00:00:00".in_time_zone,
                                             end_time: "2000-01-03 23:59:59".in_time_zone)
      end

      it "引数に渡した日付の予約のみを返す" do
        date = Date.parse("2000/1/2")
        expect(Reservation.for_the_day(date)).to match_array [reservation2]
      end
    end

    describe "finished" do
      let!(:finished_reservation) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 08:00:00".in_time_zone, end_time: "2000-01-01 08:59:59".in_time_zone)
      end
      let!(:unfinished_reservation) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 08:00:00".in_time_zone, end_time: "2000-01-01 09:00:00".in_time_zone)
      end

      before { travel_to Time.zone.local(2000, 1, 1, 9) }

      after { travel_back }

      it "end_timeが現在時刻より前の予約を返す" do
        expect(Reservation.finished).to match_array [finished_reservation]
      end
    end

    describe "unfinished" do
      let!(:finished_reservation) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 08:00:00".in_time_zone, end_time: "2000-01-01 08:59:59".in_time_zone)
      end
      let!(:unfinished_reservation) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 08:00:00".in_time_zone, end_time: "2000-01-01 09:00:00".in_time_zone)
      end

      before { travel_to Time.zone.local(2000, 1, 1, 9) }

      after { travel_back }

      it "end_timeが現在時刻以後の予約を返す" do
        expect(Reservation.unfinished).to match_array [unfinished_reservation]
      end
    end
  end
end
