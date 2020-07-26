require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "validation" do
    it "有効なファクトリを持つこと" do
      expect(user).to be_valid
    end

    it "メールアドレスが無いと無効" do
      user.email = nil
      user.valid?
      expect(user.errors.full_messages).to include "メールアドレスを入力してください"
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

  describe "enum" do
    context "genderが0〜2の時" do
      let(:enum) { { unanswered: 0, female: 1, male: 2 } }

      it "enumを返す" do
        enum.each do |key, value|
          user.gender = value
          expect(user.gender).to eq key.to_s
        end
      end
    end

    context "genderが0~2以外の時" do
      let(:invalid_enum) { [-1, 1.1, 3] }

      it "例外が発生する" do
        invalid_enum.each do |n|
          expect do
            user.gender = n
          end.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "favorite?(space)" do
    let(:space) { create(:space) }

    context "利用者がスペースをお気に入りしていた場合" do
      let!(:favorite) { create(:favorite, user: user, space: space) }

      it "trueを返す" do
        expect(user.favorite?(space)).to eq true
      end
    end

    context "利用者がスペースをお気に入りにしていない場合" do
      it "falseを返す" do
        expect(user.favorite?(space)).to eq false
      end
    end
  end
end
