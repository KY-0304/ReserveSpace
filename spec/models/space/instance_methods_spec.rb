RSpec.describe Space, type: :model do
  describe "instance_methods" do
    describe "prefecture_name" do
      let(:valid_space)   { create(:space, prefecture_code: 13) }
      let(:invalid_space) { create(:space, prefecture_code: 100) }

      context "都道府県コードが妥当な場合" do
        it "都道府県名を返す" do
          expect(valid_space.prefecture_name).to eq "東京都"
        end
      end

      context "都道府県コードが不正な場合" do
        it "nilを返す" do
          expect(invalid_space.prefecture_name).to eq nil
        end
      end
    end

    describe "prefecture_name=(prefecture_name)" do
      let(:space) { create(:space, prefecture_code: 1) }

      context "引数の都道府県名が妥当な場合" do
        it "spaceオブジェクトの都道府県コードを更新する" do
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

    describe "full_address" do
      let(:space) do
        create(:space, prefecture_code: 13, address_city: "千代田区", address_street: "千代田1-1-1", address_building: "千代田ビル")
      end

      it "結合した住所を返す" do
        expect(space.full_address).to eq "東京都千代田区千代田1-1-1千代田ビル"
      end

      it "nilの部分は無視して結合した住所を返す" do
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
end
