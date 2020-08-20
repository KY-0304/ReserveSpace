require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "class_methods" do
    describe "duplication_in_time_range" do
      let!(:reservation1) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 09:00:00".in_time_zone, end_time: "2000-01-01 12:00:00".in_time_zone)
      end
      let!(:reservation2) do
        create(:reservation, :skip_validate, start_time: "2000-01-01 13:00:00".in_time_zone, end_time: "2000-01-01 15:00:00".in_time_zone)
      end

      it "予約時間帯が引数の時間帯と重複している予約を返す" do
        times = []
        24.times { |i| times << "2000-01-01 #{i}:00:00".in_time_zone }

        expect(Reservation.duplication_in_time_range(times[9], times[12])).to match_array [reservation1]
        expect(Reservation.duplication_in_time_range(times[9], times[13])).to match_array [reservation1, reservation2]
        expect(Reservation.duplication_in_time_range(times[9], times[15])).to match_array [reservation1, reservation2]
        expect(Reservation.duplication_in_time_range(times[11], times[14])).to match_array [reservation1, reservation2]
        expect(Reservation.duplication_in_time_range(times[8], times[16])).to match_array [reservation1, reservation2]
      end
    end
  end
end
