require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:space)       { create(:space, hourly_price: 1000) }
  let(:start_time)  { "2000-01-01 09:00:00".in_time_zone }
  let(:end_time)    { "2000-01-01 12:00:00".in_time_zone }
  let(:reservation) { create(:reservation, :skip_validate, space: space, start_time: start_time, end_time: end_time) }

  describe "instance_methods" do
    describe "reservation_time" do
      it "「開始時間〜終了時間」を返す" do
        expect(reservation.reservation_time).to eq "09:00~12:00"
      end
    end

    describe "hours_of_use" do
      it "予約時間数を返す" do
        expect(reservation.hours_of_use).to eq 3
      end
    end

    describe "total_price" do
      it "料金単価＊予約時間を返す" do
        expect(reservation.total_price).to eq 3000
      end
    end
  end
end
