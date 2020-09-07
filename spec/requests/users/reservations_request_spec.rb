require 'rails_helper'

RSpec.describe "Users::Reservations", type: :request do
  let(:space)       { create(:space, hourly_price: 1000) }
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }

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

  describe "GET #new" do
    let(:params) { { space_id: space.id, start_time: Time.current, end_time: Time.current.since(1.hour) } }

    context "ログイン済みの場合" do
      before do
        sign_in user
        get new_users_reservation_path, params: { reservation: params }
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get new_users_reservation_path, params: { reservation: params }
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
    let(:params) { { space_id: space.id, start_time: Time.current, end_time: Time.current.since(2.hour) } }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      context "params[:back]が送られた場合" do
        it "ステータスコード200を返す" do
          post users_reservations_path, params: { reservation: params, back: "back" }
          expect(response.status).to eq 200
        end
      end

      context "params['payjp-token']が送られなかった場合" do
        before do
          post users_reservations_path, params: { reservation: params }
        end

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "フラッシュを返す" do
          expect(flash[:alert]).to eq "クレジットカード情報を入力してください。"
        end
      end

      context "パラメータが妥当な場合" do
        let(:api_url)           { ENV['PAYJP_CREATE_CHARGE_URL'] }
        let(:api_request_body)  { { amount: 2000, card: 'token', currency: 'jpy' } }
        let(:api_response_body) { { id: 'charge_id' }.to_json }

        before do
          WebMock.enable!
          WebMock.stub_request(:post, api_url).with(body: api_request_body).to_return(status: 200, body: api_response_body)
        end

        after do
          WebMock.disable!
        end

        it "ステータスコード302を返す" do
          post users_reservations_path, params: { reservation: params, 'payjp-token' => 'token' }
          expect(response.status).to eq 302
        end

        it "space_pathにリダイレクトする" do
          post users_reservations_path, params: { reservation: params, 'payjp-token' => 'token' }
          expect(response).to redirect_to space_path(space)
        end

        it "reservationが登録される" do
          expect do
            post users_reservations_path, params: { reservation: params, 'payjp-token' => 'token' }
          end.to change(Reservation, :count).by 1
        end

        it "フラッシュを返す" do
          post users_reservations_path, params: { reservation: params, 'payjp-token' => 'token' }
          expect(flash[:notice]).to eq "予約が完了しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:invalid_params) { { space_id: space.id, start_time: "", end_time: "" } }

        it "ステータスコード200を返す" do
          post users_reservations_path, params: { reservation: invalid_params, 'payjp-token' => 'token' }
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          post users_reservations_path, params: { reservation: invalid_params, 'payjp-token' => 'token' }
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "reservationが登録されない" do
          expect do
            post users_reservations_path, params: { reservation: invalid_params, 'payjp-token' => 'token' }
          end.not_to change(Reservation, :count)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post users_reservations_path, params: { reservation: params, 'payjp-token' => 'token' }
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
    let(:reservation) { create(:reservation, user: user, space: space, charge_id: 'charge_id') }
    let(:api_url)     { ENV['PAYJP_RETRIEVE_CHARGE_URL'] + reservation.charge_id }

    context "ログイン済みの場合" do
      before do
        sign_in user
        WebMock.enable!
        WebMock.stub_request(:get, api_url).to_return(status: 200, body: PayjpMocks.get_charge_mock.to_json)
        allow(ApiPayjp).to receive(:refund).and_return(true)
      end

      after do
        WebMock.disable!
      end

      it "ステータスコード302を返す" do
        delete users_reservation_path(reservation)
        expect(response.status).to eq 302
      end

      it "users_reservations_pathにリダイレクトする" do
        delete users_reservation_path(reservation)
        expect(response).to redirect_to users_reservations_path
      end

      it "reservationが削除される" do
        reservation
        expect do
          delete users_reservation_path(reservation)
        end.to change(Reservation, :count).by(-1)
      end

      it "フラッシュを返す" do
        delete users_reservation_path(reservation)
        expect(flash[:notice]).to eq "予約の削除が完了しました。"
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
  end
end
