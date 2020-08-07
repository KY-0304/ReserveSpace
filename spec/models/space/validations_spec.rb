require 'rails_helper'

RSpec.describe Space, type: :model do
  describe "validations" do
    let(:space) { build(:space) }

    it "有効なファクトリを持つこと" do
      expect(space).to be_valid
    end

    it "名前が無いと無効" do
      space.name = nil
      space.valid?
      expect(space.errors.full_messages).to include "名前を入力してください"
    end

    it "名前が101文字以上だと無効" do
      space.name = "a" * 101
      space.valid?
      expect(space.errors.full_messages).to include "名前は100文字以内で入力してください"
    end

    it "説明が3001文字以上だと無効" do
      space.description = "a" * 3001
      space.valid?
      expect(space.errors.full_messages).to include "説明は3000文字以内で入力してください"
    end

    it "郵便番号が無いと無効" do
      space.postcode = nil
      space.valid?
      expect(space.errors.full_messages).to include "郵便番号を入力してください"
    end

    it "都道府県が無いと無効" do
      space.prefecture_code = nil
      space.valid?
      expect(space.errors.full_messages).to include "都道府県を入力してください"
    end

    it "市区町村が無いと無効" do
      space.address_city = nil
      space.valid?
      expect(space.errors.full_messages).to include "市区町村を入力してください"
    end

    it "市区町村が21文字以上だと無効" do
      space.address_city = "a" * 21
      space.valid?
      expect(space.errors.full_messages).to include "市区町村は20文字以内で入力してください"
    end

    it "番地が無いと無効" do
      space.address_street = nil
      space.valid?
      expect(space.errors.full_messages).to include "番地を入力してください"
    end

    it "番地が31文字以上だと無効" do
      space.address_street = "a" * 31
      space.valid?
      expect(space.errors.full_messages).to include "番地は30文字以内で入力してください"
    end

    it "建物が51文字以上だと無効" do
      space.address_building = "a" * 51
      space.valid?
      expect(space.errors.full_messages).to include "建物は50文字以内で入力してください"
    end

    it "連絡先が無いと無効" do
      space.phone_number = nil
      space.valid?
      expect(space.errors.full_messages).to include "連絡先を入力してください"
    end

    it "連絡先が指定のフォーマットなら有効" do
      valid_numbers = [
        "01-1234-1234", "012-123-1234", "0123-12-1234", "01234-1-1234",
        "050-1234-1234", "070-1234-1234", "080-1234-1234", "090-1234-1234",
      ]

      valid_numbers.each do |num|
        space.phone_number = num
        expect(space).to be_valid
      end
    end

    it "連絡先が指定のフォーマットでないと無効" do
      invalid_numbers = [
        "12-1234-1234", "0-1234-1234", "012345-1234-1234", "01-12345-1234",
        "01-1234-12345", "060-1234-1234", "0123456789",
      ]

      invalid_numbers.each do |num|
        space.phone_number = num
        space.valid?
        expect(space.errors.full_messages).to include "連絡先は不正な値です"
      end
    end

    it "時間単価が無いと無効" do
      space.hourly_price = nil
      space.valid?
      expect(space.errors.full_messages).to include "時間単価を入力してください"
    end

    it "時間単価が整数でないと無効" do
      space.hourly_price = 100.1
      space.valid?
      expect(space.errors.full_messages).to include "時間単価は整数で入力してください"
    end

    it "時間単価は100円以上じゃないと無効" do
      space.hourly_price = 99
      space.valid?
      expect(space.errors.full_messages).to include "時間単価は100以上の値にしてください"
    end

    it "時間単価が100円単位でないと無効" do
      space.hourly_price = 101
      space.valid?
      expect(space.errors.full_messages).to include "時間単価は100円単位で設定してください"
    end

    it "営業開始時間が無いと無効" do
      space.business_start_time = nil
      space.valid?
      expect(space.errors.full_messages).to include "営業開始時間を入力してください"
    end

    it "営業終了時間が無いと無効" do
      space.business_end_time = nil
      space.valid?
      expect(space.errors.full_messages).to include "営業終了時間を入力してください"
    end

    it "営業終了時間は営業開始時間より後でないと無効" do
      space.business_start_time = "09:00"
      space.business_end_time = "08:00"
      space.valid?
      expect(space.errors.full_messages).to include "営業終了時間は09:00より後にしてください。"
    end
  end
end
