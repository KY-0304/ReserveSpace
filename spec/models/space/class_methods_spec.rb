require 'rails_helper'

RSpec.describe Space, type: :model do
  describe "class_methods" do
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

    describe "does_not_have_reservations" do
      let!(:hit_space)   { create(:space) }
      let(:no_hit_space) { create(:space) }
      let(:reservation) do
        create(:reservation, space: no_hit_space,
                             start_time: "2020-07-01 12:00:00".in_time_zone,
                             end_time: "2020-07-01 13:00:00".in_time_zone)
      end

      before do
        travel_to Time.zone.local(2020, 7, 1, 10)
        reservation
      end

      after { travel_back }

      it "予約を１つも持たないスペースを返す" do
        expect(Space.does_not_have_reservations).to eq [hit_space]
      end
    end

    describe "does_not_have_reservations_in_time_range" do
      let(:hit_space1)   { create(:space) }
      let(:hit_space2)   { create(:space) }
      let(:no_hit_space) { create(:space) }
      let(:hit_space2_reservation) do
        create(:reservation, space: hit_space2,
                             start_time: "2020-07-01 11:00:00".in_time_zone,
                             end_time: "2020-07-01 13:00:00".in_time_zone)
      end
      let(:no_hit_space_reservation) do
        create(:reservation, space: no_hit_space,
                             start_time: "2020-07-01 14:00:00".in_time_zone,
                             end_time: "2020-07-01 16:00:00".in_time_zone)
      end

      before do
        travel_to Time.zone.local(2020, 7, 1, 10)
        hit_space1
        hit_space2_reservation
        no_hit_space_reservation
      end

      after { travel_back }

      context "引数が妥当な場合" do
        it "引数の時間帯に予約を持たないスペースと予約を１つも持たないスペースを返す" do
          start_time = "2020-07-01 14:00:00".in_time_zone
          end_time   = "2020-07-01 15:00:00".in_time_zone
          expect(Space.does_not_have_reservations_in_time_range(start_time, end_time)).to match_array [hit_space1, hit_space2]
        end
      end

      context "引数がblankだった場合" do
        it "すべてのスペースを返す" do
          expect(Space.does_not_have_reservations_in_time_range("", "")).to eq Space.all
        end
      end
    end

    describe "users_search" do
      let!(:space) { create(:space) }

      context "パラメータがblankだった場合" do
        let(:params) { { prefecture_code: "", address_keyword: "", start_datetime: "", times: "", hourly_price: "" } }

        it "すべてのスペースを返す" do
          expect(Space.users_search(params)).to eq Space.all
        end
      end

      context "パラメータがnilだった場合" do
        let(:params) { nil }

        it "すべてのスペースを返す" do
          expect(Space.users_search(params)).to eq Space.all
        end
      end
    end
  end
end
