require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe "class_methods" do
    context "emailがguest@example.comのownerがDBに登録されている場合" do
      let!(:guest_owner) { create(:owner, email: "guest@example.com") }

      it "ゲストオーナーを返す" do
        owner = Owner.guest
        expect(owner.email).to eq "guest@example.com"
      end

      it "オーナーは増えない" do
        expect do
          Owner.guest
        end.not_to change(Owner, :count)
      end
    end

    context "emailがguest@example.comのownerがDBに登録されていない場合" do
      it "ゲストオーナーを返す" do
        owner = Owner.guest
        expect(owner.email).to eq "guest@example.com"
      end

      it "オーナーが増える" do
        expect do
          Owner.guest
        end.to change(Owner, :count).by 1
      end
    end
  end
end
