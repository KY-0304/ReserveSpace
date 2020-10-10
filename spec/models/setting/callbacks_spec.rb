RSpec.describe Setting, type: :model do
  describe "callbacks" do
    describe "set_nil_in_start_date_and_end_date" do
      let(:start_day) { Date.parse("2000/1/1") }
      let(:end_day)   { Date.parse("2000/1/2") }
      let(:setting)   { create(:setting) }

      context "reservation_unacceptableがfalseの場合" do
        before do
          setting.reservation_unacceptable = false
        end

        it "reservation_unacceptable_start_dateとreservation_unacceptable_end_dateをnilにする" do
          setting.update_attributes(reservation_unacceptable_start_date: start_day, reservation_unacceptable_end_date: end_day)
          expect(setting.reload.reservation_unacceptable_start_date).to eq nil
          expect(setting.reload.reservation_unacceptable_end_date).to eq nil
        end
      end
    end
  end
end
