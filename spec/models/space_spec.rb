require 'rails_helper'

RSpec.describe Space, type: :model do
  describe "relation" do
    let(:owner) { create(:owner) }
    let!(:space) { create(:space, owner: owner) }

    it "ownerを削除するとspaceも削除される" do
      expect do
        owner.destroy
      end.to change(Space, :count).by(-1)
    end
  end

  describe "validation" do
    let(:space) { create(:space) }

    it "有効なファクトリを持つこと" do
      expect(space).to be_valid
    end

    it "掲載者IDが無いと無効" do
      space.owner_id = nil
      space.valid?
      expect(space.errors.full_messages).to include "掲載者を入力してください"
    end

    it "名前が無いと無効" do
      space.name = nil
      space.valid?
      expect(space.errors.full_messages).to include "名前を入力してください"
    end

    it "イメージが無いと無効" do
      space.image = nil
      space.valid?
      expect(space.errors.full_messages).to include "イメージを入力してください"
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

    it "番地が無いと無効" do
      space.address_street = nil
      space.valid?
      expect(space.errors.full_messages).to include "番地を入力してください"
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

  describe "prefecture_name" do
    let(:space) { create(:space, prefecture_code: 13) }

    context "都道府県コードが妥当な場合" do
      it "都道府県名を返す" do
        expect(space.prefecture_name).to eq "東京都"
      end
    end

    context "都道府県コードが不正な場合" do
      it "nilを返す" do
        space.prefecture_code = 100
        expect(space.prefecture_name).to eq nil
      end
    end
  end

  describe "prefecture_name=(prefecture_name)" do
    let(:space) { create(:space, prefecture_code: 1) }

    context "引数の都道府県名が妥当な場合" do
      it "spaceオブジェクトの都道府県コード更新する" do
        space.prefecture_name = "東京都"
        expect(space.prefecture_code).to eq 13
      end
    end

    context "引数の都道府県名が不正な場合" do
      it "NoMethodErrorが出る" do
        expect do
          space.prefecture_name = "東京都都"
        end.to raise_error(NoMethodError)
      end
    end
  end

  describe "address" do
    let(:space) do
      create(:space, prefecture_code: 13, address_city: "千代田区", address_street: "千代田1-1-1", address_building: "千代田ビル")
    end

    it "(, )で結合した住所を返す" do
      expect(space.send(:geocode_address)).to eq "東京都, 千代田区, 千代田1-1-1, 千代田ビル"
      space.address_building = nil
      expect(space.send(:geocode_address)).to eq "東京都, 千代田区, 千代田1-1-1"
    end
  end

  describe "full_address" do
    let(:space) do
      create(:space, prefecture_code: 13, address_city: "千代田区", address_street: "千代田1-1-1", address_building: "千代田ビル")
    end

    it "結合した住所を返す" do
      expect(space.full_address).to eq "東京都千代田区千代田1-1-1千代田ビル"
      space.address_building = nil
      expect(space.full_address).to eq "東京都千代田区千代田1-1-1"
    end
  end

  describe "business_time" do
    let(:space) { create(:space, business_start_time: "09:00", business_end_time: "18:00") }

    it "営業開始時間 〜 営業終了時間の形にして返す" do
      expect(space.business_time).to eq "09:00 〜 18:00"
    end
  end
end
