require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user)  { create(:user) }
  let(:space) { create(:space) }
  let!(:reservation) do
    create(:reservation, :skip_validate, space: space, user: user, start_time: Time.current - 2.hours, end_time: Time.current - 1.hour)
  end

  describe "association" do
    it "spaceを削除するとreservationも削除される" do
      expect do
        space.destroy
      end.to change(Reservation, :count).by(-1)
    end

    it "userを削除するとreservationも削除される" do
      expect do
        user.destroy
      end.to change(Reservation, :count).by(-1)
    end
  end
end
