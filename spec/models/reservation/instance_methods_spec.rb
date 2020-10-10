RSpec.describe Reservation, type: :model do
  describe "instance_methods" do
    let(:space)       { create(:space, hourly_price: 1000) }
    let(:start_time)  { "2000-01-01 09:00:00".in_time_zone }
    let(:end_time)    { "2000-01-01 12:00:00".in_time_zone }
    let(:reservation) { create(:reservation, :skip_validate, space: space, start_time: start_time, end_time: end_time) }

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

    describe "owners_sales_amount" do
      it "total_priceからReserveSpaceの手数料を引いた値を返す" do
        expect(reservation.owners_sales_amount).to eq 2700
      end
    end

    describe "reserve_space_sales_amount" do
      it "total_priceからReserveSpaceの手数料分を返す" do
        expect(reservation.reserve_space_sales_amount).to eq 300
      end
    end

    describe "cancelable?" do
      let(:reservation1) { create(:reservation, :skip_validate, start_time: "2000-01-01 00:00:00".in_time_zone) }
      let(:reservation2) { create(:reservation, :skip_validate, start_time: "2000-01-02 00:00:00".in_time_zone) }
      let(:reservation3) { create(:reservation, :skip_validate, start_time: "2000-01-03 00:00:00".in_time_zone) }

      before { travel_to Time.zone.local(2000, 1, 2) }

      after { travel_back }

      it "予約開始日が翌日以降の時、trueを返す" do
        expect(reservation1.cancelable?).to eq false
        expect(reservation2.cancelable?).to eq false
        expect(reservation3.cancelable?).to eq true
      end
    end
  end
end
