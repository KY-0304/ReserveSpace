require 'rails_helper'

RSpec.describe User, type: :model do
  describe "class_methods" do
    describe "User.guest" do
      context "emailがguest@example.comのuserがDBに登録されている場合" do
        let!(:guest_user) { create(:user, email: "guest@example.com") }

        it "ゲストユーザーを返す" do
          user = User.guest
          expect(user.email).to eq "guest@example.com"
        end

        it "ユーザーは増えない" do
          expect do
            User.guest
          end.not_to change(User, :count)
        end
      end

      context "emailがguest@example.comのuserがDBに登録されていない場合" do
        it "ゲストユーザーを返す" do
          user = User.guest
          expect(user.email).to eq "guest@example.com"
        end

        it "ユーザーが増える" do
          expect do
            User.guest
          end.to change(User, :count).by 1
        end
      end
    end
  end
end
