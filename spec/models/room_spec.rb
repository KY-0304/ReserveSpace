require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "validation" do
    let(:room) { create(:room) }

    it "有効なファクトリを持つこと" do
      expect(room).to be_valid
    end

    it "オーナーIDが無いと無効" do
      room.owner_id = nil
      room.valid?
      expect(room.errors.full_messages).to include "オーナーを入力してください"
    end

    it "名前が無いと無効" do
      room.name = nil
      room.valid?
      expect(room.errors.full_messages).to include "名前を入力してください"
    end

    it "イメージが無いと無効" do
      room.image = nil
      room.valid?
      expect(room.errors.full_messages).to include "イメージを入力してください"
    end

    it "郵便番号が無いと無効" do
      room.postcode = nil
      room.valid?
      expect(room.errors.full_messages).to include "郵便番号を入力してください"
    end

    it "都道府県が無いと無効" do
      room.prefecture_code = nil
      room.valid?
      expect(room.errors.full_messages).to include "都道府県を入力してください"
    end

    it "市区町村が無いと無効" do
      room.address_city = nil
      room.valid?
      expect(room.errors.full_messages).to include "市区町村を入力してください"
    end

    it "番地が無いと無効" do
      room.address_street = nil
      room.valid?
      expect(room.errors.full_messages).to include "番地を入力してください"
    end

    it "連絡先が無いと無効" do
      room.phone_number = nil
      room.valid?
      expect(room.errors.full_messages).to include "連絡先を入力してください"
    end

    it "連絡先が指定のフォーマットなら有効" do
      valid_numbers = [
        "01-1234-1234", "012-123-1234", "0123-12-1234", "01234-1-1234",
        "050-1234-1234", "070-1234-1234", "080-1234-1234", "090-1234-1234",
      ]

      valid_numbers.each do |num|
        room.phone_number = num
        expect(room).to be_valid
      end
    end

    it "連絡先が指定のフォーマットでないと無効" do
      invalid_numbers = [
        "12-1234-1234", "0-1234-1234", "012345-1234-1234", "01-12345-1234",
        "01-1234-12345", "060-1234-1234", "0123456789",
      ]

      invalid_numbers.each do |num|
        room.phone_number = num
        room.valid?
        expect(room.errors.full_messages).to include "連絡先は不正な値です"
      end
    end

    it "時間単価が無いと無効" do
      room.hourly_price = nil
      room.valid?
      expect(room.errors.full_messages).to include "時間単価を入力してください"
    end

    it "時間単価が負の値だと無効" do
      room.hourly_price = "-1"
      room.valid?
      expect(room.errors.full_messages).to include "時間単価は負の値を指定できません"
    end

    it "時間単価が100円単位でないと無効" do
      room.hourly_price = "101"
      room.valid?
      expect(room.errors.full_messages).to include "時間単価は100円単位で設定してください"
    end

    it "営業開始時間が無いと無効" do
      room.business_start_time = nil
      room.valid?
      expect(room.errors.full_messages).to include "営業開始時間を入力してください"
    end

    it "営業終了時間が無いと無効" do
      room.business_end_time = nil
      room.valid?
      expect(room.errors.full_messages).to include "営業終了時間を入力してください"
    end

    it "営業開始時間と営業終了時間が同じだと無効" do
      room.business_start_time = "09:00"
      room.business_end_time = "09:00"
      room.valid?
      expect(room.errors.full_messages).to include "営業終了時間は営業開始時間と同じ値を指定できません"
    end
  end

  describe "prefecture_name" do
    let(:room) { create(:room, prefecture_code: 13) }

    context "都道府県コードが妥当な場合" do
      it "都道府県名を返す" do
        expect(room.prefecture_name).to eq "東京都"
      end
    end

    context "都道府県コードが不正な場合" do
      it "nilを返す" do
        room.prefecture_code = 100
        expect(room.prefecture_name).to eq nil
      end
    end
  end

  describe "prefecture_name=(prefecture_name)" do
    let(:room) { create(:room, prefecture_code: 1) }

    context "引数の都道府県名が妥当な場合" do
      it "roomオブジェクトの都道府県コード更新する" do
        room.prefecture_name = "東京都"
        expect(room.prefecture_code).to eq 13
      end
    end

    context "引数の都道府県名が不正な場合" do
      it "NoMethodErrorが出る" do
        expect do
          room.prefecture_name = "東京都都"
        end.to raise_error(NoMethodError)
      end
    end
  end

  describe "full_address" do
    let(:room) { create(:room, prefecture_code: 13, address_city: "千代田区", address_street: "千代田1-1-1", address_building: "千代田ビル") }

    it "結合した住所を返す" do
      expect(room.full_address).to eq "東京都千代田区千代田1-1-1千代田ビル"
      room.address_building = nil
      expect(room.full_address).to eq "東京都千代田区千代田1-1-1"
    end
  end
end
