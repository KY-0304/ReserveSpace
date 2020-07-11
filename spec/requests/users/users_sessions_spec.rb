require 'rails_helper'

RSpec.describe "UsersSessions", type: :request do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "ステータスコード200を返す" do
      get new_user_session_path
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    before do
      post user_session_path, params: { user: params }
    end

    context "パラメータが妥当な場合" do
      let(:params) { { email: user.email, password: user.password } }

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "root_pathにリダイレクトする" do
        expect(response).to redirect_to root_path
      end

      it "フラッシュを返す" do
        expect(flash[:notice]).to eq "ログインしました"
      end
    end

    context "パラメータが不正な場合" do
      let(:params) { { email: "", password: user.password } }

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end

      it "フラッシュを返す" do
        expect(flash[:alert]).to eq "メールアドレスまたはパスワードが違います"
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in user
      delete destroy_user_session_path
    end

    it "ステータスコード302を返す" do
      expect(response.status).to eq 302
    end

    it "root_pathにリダイレクトする" do
      expect(response).to redirect_to root_path
    end

    it "フラッシュを返す" do
      expect(flash[:notice]).to eq "ログアウトしました"
    end
  end
end
