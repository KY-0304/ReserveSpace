require 'rails_helper'

RSpec.describe "Users::Favorites", type: :request do
  let(:user)  { create(:user) }
  let(:space) { create(:space) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "ステータスコード200を返す" do
        get users_favorites_path
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get users_favorites_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POSE #create" do
    let(:params) { { space_id: space.id } }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "favoriteが登録される" do
        expect do
          post users_favorites_path, params: params
        end.to change(user.favorites, :count).by 1
      end
    end

    context "ログインしていない場合" do
      before do
        post users_favorites_path, params: params
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:favorite) { create(:favorite, user: user, space: space) }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "favoriteが削除される" do
        expect do
          delete users_favorite_path(favorite)
        end.to change(user.favorites, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      before do
        delete users_favorite_path(favorite)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
