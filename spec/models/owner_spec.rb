require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe "associations" do
    let(:owner)  { create(:owner) }
    let!(:space) { create(:space, owner: owner) }

    it "ownerを削除するとspaceも削除される" do
      expect do
        owner.destroy
      end.to change(Owner, :count).by(-1).and change(Space, :count).by(-1)
    end
  end

  describe "callbacks" do
    let(:owner)       { create(:owner) }
    let(:space)       { create(:space, owner: owner) }
    let(:reservation) { create(:reservation, :skip_validate, space: space, start_time: Time.current + 1.hour, end_time: Time.current + 2.hours) }

    it "spaceの全削除が完了しないとownerの削除はされない" do
      expect do
        owner.destroy
      end.not_to change(Owner, :count)
    end
  end

  describe "validation" do
    let(:owner) { create(:owner) }

    it "有効なファクトリを持つこと" do
      expect(owner).to be_valid
    end

    it "会社名が無いと無効" do
      owner.company_name = nil
      owner.valid?
      expect(owner.errors.full_messages).to include "会社名を入力してください"
    end

    it "同じ会社名は無効" do
      other_owner = owner.dup
      other_owner.valid?
      expect(other_owner.errors.full_messages).to include "会社名はすでに存在します"
    end

    it "会社名が141文字以上だと無効" do
      owner.company_name = "a" * 141
      owner.valid?
      expect(owner.errors.full_messages).to include "会社名は140文字以内で入力してください"
    end

    it "メールアドレスが無いと無効" do
      owner.email = nil
      owner.valid?
      expect(owner.errors.full_messages).to include "メールアドレスを入力してください"
    end

    it "メールアドレスが256文字以上だと無効" do
      owner.email = "a" * 256
      owner.valid?
      expect(owner.errors.full_messages).to include "メールアドレスは255文字以内で入力してください"
    end

    it "同じメールアドレスは無効" do
      other_owner = owner.dup
      other_owner.valid?
      expect(other_owner.errors.full_messages).to include "メールアドレスはすでに存在します"
    end

    it "パスワードが無いと無効" do
      owner.password = nil
      owner.valid?
      expect(owner.errors.full_messages).to include "パスワードを入力してください"
    end

    it "パスワードが5文字以下だと無効" do
      owner.password = "12345"
      owner.valid?
      expect(owner.errors.full_messages).to include "パスワードは6文字以上で入力してください"
    end

    it "パスワードと確認用パスワードが一致しないと無効" do
      owner.password              = "password"
      owner.password_confirmation = "password_diff"
      owner.valid?
      expect(owner.errors.full_messages).to include "確認用パスワードとパスワードの入力が一致しません"
    end
  end

  describe "class_methods" do
    context "emailがguest@example.comのオーナーがDBに登録されている場合" do
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

    context "emailがguest@example.comのオーナーがDBに登録されていない場合" do
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
