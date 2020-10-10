RSpec.describe User, type: :model do
  describe "associations" do
    let(:user)         { create(:user) }
    let!(:favorite)    { create(:favorite, user: user) }
    let!(:review)      { create(:review, :skip_validate, user: user) }
    let!(:reservation) { create(:reservation, :skip_validate, user: user, start_time: Time.current - 2.hours, end_time: Time.current - 1.hour) }

    it "userを削除するとfavoriteも削除される" do
      expect do
        user.destroy
      end.to change(Favorite, :count).by(-1).and change(User, :count).by(-1)
    end

    it "userを削除するとreviewも削除される" do
      expect do
        user.destroy
      end.to change(Review, :count).by(-1).and change(User, :count).by(-1)
    end

    it "userを削除するとreservationも削除される" do
      expect do
        user.destroy
      end.to change(Reservation, :count).by(-1).and change(User, :count).by(-1)
    end
  end
end
