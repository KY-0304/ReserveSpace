require 'rails_helper'

RSpec.describe User, type: :model do
  describe "callbacks" do
    describe "check_all_reservations_finished" do
      let!(:user) { create(:user) }

      context "完了していない予約がある場合" do
        let!(:reservation) { create(:reservation, :skip_validate, user: user, start_time: Time.current, end_time: Time.current + 1.minute) }

        it "userを削除できない" do
          expect do
            user.destroy
          end.not_to change(User, :count)
        end
      end

      context "完了していない予約が無い場合" do
        it "userを削除できる" do
          expect do
            user.destroy
          end.to change(User, :count).by(-1)
        end
      end
    end
  end
end
