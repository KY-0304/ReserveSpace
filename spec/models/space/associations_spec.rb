RSpec.describe Space, type: :model do
  describe "associations" do
    let(:space)        { create(:space) }
    let!(:favorite)    { create(:favorite, space: space) }
    let!(:review)      { create(:review, :skip_validate, space: space) }
    let!(:reservation) { create(:reservation, :skip_validate, space: space, end_time: Time.current - 1.second) }

    it "spaceを削除するとfavoriteも削除される" do
      expect do
        space.destroy
      end.to change(Favorite, :count).by(-1).and change(Space, :count).by(-1)
    end

    it "spaceを削除するとreviewも削除される" do
      expect do
        space.destroy
      end.to change(Review, :count).by(-1).and change(Space, :count).by(-1)
    end

    it "spaceを削除するとreservationも削除される" do
      expect do
        space.destroy
      end.to change(Reservation, :count).by(-1).and change(Space, :count).by(-1)
    end

    it "spaceを削除するとsettingも削除される" do
      expect do
        space.destroy
      end.to change(Setting, :count).by(-1).and change(Space, :count).by(-1)
    end
  end
end
