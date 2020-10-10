RSpec.describe User, type: :model do
  describe "validation" do
    let(:user) { create(:user) }

    it "有効なファクトリを持つこと" do
      expect(user).to be_valid
    end

    it "メールアドレスが無いと無効" do
      user.email = nil
      user.valid?
      expect(user.errors.full_messages).to include "メールアドレスを入力してください"
    end

    it "メールアドレスが256文字以上だと無効" do
      user.email = "a" * 256
      user.valid?
      expect(user.errors.full_messages).to include "メールアドレスは255文字以内で入力してください"
    end

    it "同じメールアドレスは無効" do
      other_user = user.dup
      other_user.valid?
      expect(other_user.errors.full_messages).to include "メールアドレスはすでに存在します"
    end

    it "パスワードが無いと無効" do
      user.password = nil
      user.valid?
      expect(user.errors.full_messages).to include "パスワードを入力してください"
    end

    it "パスワードが5文字以下だと無効" do
      user.password = "12345"
      user.valid?
      expect(user.errors.full_messages).to include "パスワードは6文字以上で入力してください"
    end

    it "パスワードと確認用パスワードが一致しないと無効" do
      user.password              = "password"
      user.password_confirmation = "password_diff"
      user.valid?
      expect(user.errors.full_messages).to include "確認用パスワードとパスワードの入力が一致しません"
    end

    it "名前が無いと無効" do
      user.name = nil
      user.valid?
      expect(user.errors.full_messages).to include "名前を入力してください"
    end

    it "名前が31文字以上だと無効" do
      user.name = "a" * 31
      user.valid?
      expect(user.errors.full_messages).to include "名前は30文字以内で入力してください"
    end

    it "連絡先が無いと無効" do
      user.phone_number = nil
      user.valid?
      expect(user.errors.full_messages).to include "連絡先を入力してください"
    end

    it "連絡先が指定のフォーマットなら有効" do
      valid_numbers = [
        "01-1234-1234", "012-123-1234", "0123-12-1234", "01234-1-1234",
        "050-1234-1234", "070-1234-1234", "080-1234-1234", "090-1234-1234",
      ]

      valid_numbers.each do |num|
        user.phone_number = num
        expect(user).to be_valid
      end
    end

    it "連絡先が指定のフォーマットでないと無効" do
      invalid_numbers = [
        "12-1234-1234", "0-1234-1234", "012345-1234-1234", "01-12345-1234",
        "01-1234-12345", "060-1234-1234", "0123456789",
      ]

      invalid_numbers.each do |num|
        user.phone_number = num
        user.valid?
        expect(user.errors.full_messages).to include "連絡先は不正な値です"
      end
    end

    it "性別が無いと無効" do
      user.gender = nil
      user.valid?
      expect(user.errors.full_messages).to include "性別を入力してください"
    end
  end
end
