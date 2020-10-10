RSpec.describe Space, type: :model do
  describe "class_methods" do
    describe "users_search" do
      let!(:space) { create_list(:space, 5) }

      context "パラメータがblankだった場合" do
        let(:params) { { prefecture_code: "", address_keyword: "", start_datetime: "", times: "", hourly_price: "" } }

        it "すべてのスペースを返す" do
          expect(Space.users_search(params)).to match_array Space.all
        end
      end

      context "パラメータがnilだった場合" do
        let(:params) { nil }

        it "すべてのスペースを返す" do
          expect(Space.users_search(params)).to match_array Space.all
        end
      end
    end

    describe "hourly_price_less_than_or_equal" do
      let!(:hit_space1)    { create(:space, hourly_price: 900) }
      let!(:hit_space2)    { create(:space, hourly_price: 1000) }
      let!(:no_hit_space)  { create(:space, hourly_price: 1100) }

      context "引数が妥当な場合" do
        it "引数以下の時間単価を持つスペースを返す" do
          expect(Space.hourly_price_less_than_or_equal(1000)).to match_array [hit_space1, hit_space2]
        end
      end

      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.hourly_price_less_than_or_equal("")).to eq Space.all
        end
      end
    end

    describe "capacity_more_than_or_equal" do
      let!(:hit_space1)   { create(:space, capacity: 3) }
      let!(:hit_space2)   { create(:space, capacity: 2) }
      let!(:no_hit_space) { create(:space, capacity: 1) }

      context "引数が妥当な場合" do
        it "引数以上の収容人数を持つスペースを返す" do
          expect(Space.capacity_more_than_or_equal(2)).to match_array [hit_space1, hit_space2]
        end
      end

      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.capacity_more_than_or_equal("")).to eq Space.all
        end
      end
    end

    describe "match_prefecture_code" do
      let!(:hit_space)    { create(:space, prefecture_code: 13) }
      let!(:no_hit_space) { create(:space, prefecture_code: 12) }

      context "引数が妥当な場合" do
        it "引数と同じ都道府県コードを持つスペースを返す" do
          expect(Space.match_prefecture_code(13)).to match_array [hit_space]
        end
      end

      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.match_prefecture_code("")).to eq Space.all
        end
      end
    end

    describe "include_address_search_keyword" do
      let!(:space1) { create(:space, address_city: "港区",    address_street: "三田1-1-1",   address_building: "testビル") }
      let!(:space2) { create(:space, address_city: "港区",    address_street: "三田1-1-1",   address_building: "") }
      let!(:space3) { create(:space, address_city: "千代田区", address_street: "千代田1-1-1", address_building: "testビル") }

      context "引数が妥当な場合" do
        it "キーワードが市区町村、番地、建物を結合したものに含まれているスペースを返す" do
          expect(Space.include_address_search_keyword("区三田1-1-1test")).to match_array [space1]
          expect(Space.include_address_search_keyword("港区三田1-1-1")).to match_array [space1, space2]
        end
      end

      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.include_address_search_keyword("")).to eq Space.all
        end
      end
    end

    describe "does_not_have_reservations_in_time_range" do
      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.does_not_have_reservations_in_time_range("", "")).to eq Space.all
        end
      end
    end

    describe "reservation_acceptable_in_period" do
      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.reservation_acceptable_in_period("", "")).to eq Space.all
        end
      end
    end

    describe "reservation_acceptable_in_same_day" do
      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.reservation_acceptable_in_same_day("")).to eq Space.all
        end
      end
    end

    describe "reservation_acceptable_within_until_day" do
      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.reservation_acceptable_within_until_day("")).to eq Space.all
        end
      end
    end
  end
end
