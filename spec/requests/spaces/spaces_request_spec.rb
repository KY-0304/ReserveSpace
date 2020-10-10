RSpec.describe "Spaces", type: :request do
  let(:owner)       { create(:owner) }
  let!(:space)      { create(:space, owner: owner, name: "test_space") }
  let(:other_owner) { create(:owner) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get spaces_path
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get spaces_path
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
      get space_path(space)
      expect(response.status).to eq 200
    end

    it "impressionsテーブルのレコードが増える" do
      expect do
        get space_path(space)
      end.to change(Impression, :count).by 1
    end

    it "spaceのimpressions_countがインクリメントされる" do
      get space_path(space)
      expect(space.reload.impressions_count).to eq 1
    end
  end

  describe "GET #new" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get new_space_path
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get new_space_path
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
    let(:params) { attributes_for(:space) }

    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          post spaces_path, params: { space: params }
          expect(response.status).to eq 302
        end

        it "spaces_pathにリダイレクトする" do
          post spaces_path, params: { space: params }
          expect(response).to redirect_to spaces_path
        end

        it "spaceが登録される" do
          expect do
            post spaces_path, params: { space: params }
          end.to change(Space, :count).by 1
        end

        it "フラッシュを返す" do
          post spaces_path, params: { space: params }
          expect(flash[:notice]).to eq "スペースの登録を完了しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:invalid_params) { attributes_for(:space, name: "") }

        it "ステータスコード200を返す" do
          post spaces_path, params: { space: invalid_params }
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          post spaces_path, params: { space: invalid_params }
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "spaceが登録されない" do
          expect do
            post spaces_path, params: { space: invalid_params }
          end.not_to change(Space, :count)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post spaces_path, params: { space: params }
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
        get edit_space_path(space)
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_space_path(space)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "PUT #update" do
    let(:params) { attributes_for(:space, name: "update_space") }

    context "ログイン済みの場合" do
      before do
        sign_in owner
        put space_path(space), params: { space: params }
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          expect(response.status).to eq 302
        end

        it "spaces_pathにリダイレクトする" do
          expect(response).to redirect_to spaces_path
        end

        it "spaceが変更される" do
          space.reload
          expect(space.name).to eq "update_space"
        end

        it "フラッシュを返す" do
          expect(flash[:notice]).to eq "スペースの編集が完了しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:params) { attributes_for(:space, name: "") }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "spaceが変更されない" do
          space.reload
          expect(space.name).to eq "test_space"
        end
      end
    end

    context "ログインしていない場合" do
      before do
        put space_path(space), params: { space: params }
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_sessin_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let(:reservation) { build(:reservation, space: space, start_time: start_time, end_time: end_time) }

    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      context "現在以降に予約が無い場合" do
        let(:start_time)  { "2000-01-01 09:00:00".in_time_zone }
        let(:end_time)    { "2000-01-01 11:00:00".in_time_zone }

        before do
          travel_to Time.zone.local(2000, 1, 1) do
            reservation.save
          end
          travel_to Time.zone.local(2000, 1, 2)
        end

        after { travel_back }

        it "ステータスコード302を返す" do
          delete space_path(space)
          expect(response.status).to eq 302
        end

        it "spaces_pathにリダイレクトする" do
          delete space_path(space)
          expect(response).to redirect_to spaces_path
        end

        it "スペースが削除される" do
          expect do
            delete space_path(space)
          end.to change(Space, :count).by(-1)
        end

        it "フラッシュを返す" do
          delete space_path(space)
          expect(flash[:notice]).to eq "スペースの削除が完了しました"
        end
      end

      context "現在以降に予約がある場合" do
        let(:start_time)  { "2000-01-02 09:00:00".in_time_zone }
        let(:end_time)    { "2000-01-02 11:00:00".in_time_zone }

        before do
          travel_to Time.zone.local(2000, 1, 1)
          reservation.save
        end

        after { travel_back }

        it "ステータスコード200を返す" do
          delete space_path(space)
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          delete space_path(space)
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "スペースは削除されない" do
          expect do
            delete space_path(space)
          end.not_to change(Space, :count)
        end
      end
    end

    context "ログインしていない場合" do
      it "ステータスコード302を返す" do
        delete space_path(space)
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        delete space_path(space)
        expect(response).to redirect_to new_owner_session_path
      end

      it "スペースは削除されない" do
        expect do
          delete space_path(space)
        end.not_to change(Space, :count)
      end
    end
  end
end
