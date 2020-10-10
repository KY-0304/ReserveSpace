RSpec.describe Owner, type: :model do
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
end
