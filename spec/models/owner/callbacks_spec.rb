require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe "callbacks" do
    describe "check_all_space_destroyed" do
      let(:owner) { create(:owner) }
      let(:space) { create(:space, owner: owner) }

      before { travel_to Time.zone.local(2000, 1, 1) }

      after { travel_back }

      context "spaceが全削除できた場合" do
        let!(:reservation) { create(:reservation, :skip_validate, space: space, end_time: Time.current - 1.second) }

        it "ownerは削除される" do
          expect do
            owner.destroy
          end.to change(Owner, :count).by(-1) and change(Space, :count).by(-1)
        end
      end

      context "spaceが全削除できなかった場合" do
        let!(:reservation) { create(:reservation, :skip_validate, space: space, end_time: Time.current) }

        it "ownerは削除されない" do
          expect do
            owner.destroy
          end.not_to change(Owner, :count)

          expect do
            owner.destroy
          end.not_to change(Space, :count)
        end
      end
    end
  end
end
