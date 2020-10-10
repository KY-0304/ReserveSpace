RSpec.describe Space, type: :model do
  describe "callbacks" do
    describe "setting_create" do
      let(:space) { build(:space) }

      it "spaceを作成するとsettingも作成される" do
        expect do
          space.save
        end.to change(Setting, :count).by(1).and change(Space, :count).by(1)
      end
    end

    describe "check_all_reservations_finished" do
      let!(:space) { create(:space) }

      context "未完了の予約がある場合" do
        let!(:reservation) { create(:reservation, :skip_validate, space: space, end_time: Time.current + 1.hour) }

        it "spaceを削除できない" do
          expect do
            space.destroy
          end.not_to change(Space, :count)
        end
      end

      context "未完了の予約が無い場合" do
        it "spaceを削除できる" do
          expect do
            space.destroy
          end.to change(Space, :count).by(-1)
        end
      end
    end
  end
end
