require 'rails_helper'

RSpec.describe "Owners::Reservations", type: :request do
  let(:owner) { create(:owner) }
  let(:room) { create(:room, owner: owner) }
  let(:reservation) { create(:reservation, room: room) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
        get owners_reservations_path
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get owners_reservations_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "GET #show" do
    before { travel_to Time.zone.local(2020, 7, 1, 10) }

    after { travel_back }

    context "ログイン済みの場合" do
      before do
        sign_in owner
        get owners_reservation_path(reservation)
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get owners_reservation_path(reservation)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end
end
