require 'rails_helper'

RSpec.describe "Users::Reservations", type: :request do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:reservation) { create(:reservation, user: user, room: room) }

  before { travel_to Time.zone.local(2020, 7, 1, 10) }

  after { travel_back }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get users_reservations_path
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get users_reservations_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #show" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get users_reservation_path(reservation)
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get users_reservation_path(reservation)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    let(:params) { { room_id: room.id, start_time: Time.current, end_time: Time.current.since(1.hour) } }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          post users_reservations_path, params: { reservation: params }
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          post users_reservations_path, params: { reservation: params }
          expect(response).to redirect_to root_path
        end

        it "reservationが登録される" do
          expect do
            post users_reservations_path, params: { reservation: params }
          end.to change(Reservation, :count).by 1
        end

        it "フラッシュを返す" do
          post users_reservations_path, params: { reservation: params }
          expect(flash[:success]).to eq "予約が完了しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:invalid_params) { { room_id: room.id, start_time: "", end_time: "" } }

        it "ステータスコード200を返す" do
          post users_reservations_path, params: { reservation: invalid_params }
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          post users_reservations_path, params: { reservation: invalid_params }
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "reservationが登録されない" do
          expect do
            post users_reservations_path, params: { reservation: invalid_params }
          end.not_to change(Reservation, :count)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post users_reservations_path, params: { reservation: params }
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_sessin_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "delete #destroy" do
    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "ステータスコード302を返す" do
        delete users_reservation_path(reservation)
        expect(response.status).to eq 302
      end

      it "root_pathにリダイレクトする" do
        delete users_reservation_path(reservation)
        expect(response).to redirect_to root_path
      end

      it "reservationが削除される" do
        reservation
        expect do
          delete users_reservation_path(reservation)
        end.to change(Reservation, :count).by(-1)
      end

      it "フラッシュを返す" do
        delete users_reservation_path(reservation)
        expect(flash[:success]).to eq "予約の削除が完了しました。"
      end
    end

    context "ログインしていない場合" do
      it "ステータスコード302を返す" do
        delete users_reservation_path(reservation)
        expect(response.status).to eq 302
      end

      it "new_user_sessin_pathにリダイレクトする" do
        delete users_reservation_path(reservation)
        expect(response).to redirect_to new_user_session_path
      end

      it "reservationが削除される" do
        reservation
        expect do
          delete users_reservation_path(reservation)
        end.not_to change(Reservation, :count)
      end
    end

    context "他の利用者がリクエストを送った場合" do
      before do
        sign_in other_user
        delete users_reservation_path(reservation)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "root_pathにリダイレクトする" do
        expect(response).to redirect_to root_path
      end

      it "フラッシュを返す" do
        expect(flash[:warning]).to eq "予約が見つかりませんでした"
      end
    end
  end
end
