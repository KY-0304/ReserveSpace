require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let(:owner)    { create(:owner) }
  let(:space)    { create(:space, owner: owner) }
  let(:setting)  { space.setting }

  describe "GET#edit" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get edit_space_setting_path(space)
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_space_setting_path(space)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "PUT#update" do
    let(:params) do
      attributes_for(:setting, reservation_unacceptable: true,
                               reservation_unacceptable_start_date: start_day,
                               reservation_unacceptable_end_date: end_day,
                               reject_same_day_reservation: true,
                               accepted_until_day: 30)
    end
    let(:start_day) { Date.parse("2000/1/1") }
    let(:end_day)   { Date.parse("2000/1/2") }

    before { travel_to Time.zone.local(2000, 1, 1) }

    after { travel_back }

    context "ログイン済みの場合" do
      before do
        sign_in owner
        put space_setting_path(space), params: { setting: params }
      end

      context "パラメーターが妥当な場合" do
        it "ステータスコード302を返す" do
          expect(response.status).to eq 302
        end

        it "space_pathにリダイレクトする" do
          expect(response).to redirect_to space_path(space)
        end

        it "フラッシュを返す" do
          expect(flash[:notice]).to eq "設定を保存しました。"
        end

        it "設定が変更される" do
          expect(setting.reload.reservation_unacceptable).to eq true
          expect(setting.reload.reservation_unacceptable_start_date).to eq start_day
          expect(setting.reload.reservation_unacceptable_end_date).to eq end_day
          expect(setting.reload.reject_same_day_reservation).to eq true
          expect(setting.reload.accepted_until_day).to eq 30
        end
      end

      context "パラメーターが不正な場合" do
        let(:start_day) { Date.parse("2000/1/2") }
        let(:end_day)   { Date.parse("2000/1/1") }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "設定が変更されない" do
          expect(setting.reload.reservation_unacceptable).to eq false
        end
      end
    end

    context "ログインしていない場合" do
      before do
        put space_setting_path(space), params: { setting: params }
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
