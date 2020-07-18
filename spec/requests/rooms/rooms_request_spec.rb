require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:owner) { create(:owner) }
  let!(:room) { create(:room, owner: owner, name: "test_room") }
  let(:other_owner) { create(:owner) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get rooms_path
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get rooms_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end

      it "フラッシュを返す" do
        expect(flash[:alert]).to eq "ログインまたは登録が必要です"
      end
    end
  end

  describe "GET #show" do
    it "ステータスコード200を返す" do
      get room_path(room)
      expect(response.status).to eq 200
    end
  end

  describe "GET #new" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get new_room_path
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get new_room_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "POST #create" do
    let(:params) { attributes_for(:room) }

    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          post rooms_path, params: { room: params }
          expect(response.status).to eq 302
        end

        it "rooms_pathにリダイレクトする" do
          post rooms_path, params: { room: params }
          expect(response).to redirect_to rooms_path
        end

        it "roomが登録される" do
          expect do
            post rooms_path, params: { room: params }
          end.to change(Room, :count).by 1
        end

        it "フラッシュを返す" do
          post rooms_path, params: { room: params }
          expect(flash[:success]).to eq "会議室の登録を完了しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:invalid_params) { attributes_for(:room, name: "") }

        it "ステータスコード200を返す" do
          post rooms_path, params: { room: invalid_params }
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          post rooms_path, params: { room: invalid_params }
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "roomが登録されない" do
          expect do
            post rooms_path, params: { room: invalid_params }
          end.not_to change(Room, :count)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post rooms_path, params: { room: params }
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_sessin_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "GET #edit" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get edit_room_path(room)
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_room_path(room)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end

    context "他の掲載者がリクエストを送った場合" do
      before do
        sign_in other_owner
        get edit_room_path(room)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "rooms_pathにリダイレクトする" do
        expect(response).to redirect_to rooms_path
      end

      it "フラッシュを返す" do
        expect(flash[:warning]).to eq "会議室が見つかりませんでした"
      end
    end
  end

  describe "PUT #update" do
    let(:params) { attributes_for(:room, name: "update_room") }

    context "ログイン済みの場合" do
      before do
        sign_in owner
        put room_path(room), params: { room: params }
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          expect(response.status).to eq 302
        end

        it "rooms_pathにリダイレクトする" do
          expect(response).to redirect_to rooms_path
        end

        it "roomが変更される" do
          room.reload
          expect(room.name).to eq "update_room"
        end

        it "フラッシュを返す" do
          expect(flash[:success]).to eq "会議室の編集が完了しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:params) { attributes_for(:room, name: "") }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "roomが変更されない" do
          room.reload
          expect(room.name).to eq "test_room"
        end
      end
    end

    context "ログインしていない場合" do
      before do
        put room_path(room), params: { room: params }
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_sessin_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end

    context "他の掲載者がリクエストを送った場合" do
      before do
        sign_in other_owner
        put room_path(room), params: { room: params }
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "rooms_pathにリダイレクトする" do
        expect(response).to redirect_to rooms_path
      end

      it "フラッシュを返す" do
        expect(flash[:warning]).to eq "会議室が見つかりませんでした"
      end
    end
  end

  describe "DELETE #destroy" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード302を返す" do
        delete room_path(room)
        expect(response.status).to eq 302
      end

      it "rooms_pathにリダイレクトする" do
        delete room_path(room)
        expect(response).to redirect_to rooms_path
      end

      it "会議室が削除される" do
        expect do
          delete room_path(room)
        end.to change(Room, :count).by(-1)
      end

      it "フラッシュを返す" do
        delete room_path(room)
        expect(flash[:success]).to eq "会議室の削除が完了しました"
      end
    end

    context "ログインしていない場合" do
      it "ステータスコード302を返す" do
        delete room_path(room)
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        delete room_path(room)
        expect(response).to redirect_to new_owner_session_path
      end

      it "会議室は削除されない" do
        expect do
          delete room_path(room)
        end.not_to change(Room, :count)
      end
    end

    context "他の掲載者がリクエストを送った場合" do
      before do
        sign_in other_owner
        delete room_path(room)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "rooms_pathにリダイレクトする" do
        expect(response).to redirect_to rooms_path
      end

      it "フラッシュを返す" do
        expect(flash[:warning]).to eq "会議室が見つかりませんでした"
      end
    end
  end
end
