RSpec.describe "UsersSessions", type: :request do
  let(:user)  { create(:user) }
  let(:owner) { create(:owner) }

  describe "GET #new" do
    it "ステータスコード200を返す" do
      get new_user_session_path
      expect(response.status).to eq 200
    end

    context "オーナーでログインしている場合" do
      before do
        sign_in owner
        get new_user_session_path
      end

      it "root_pathにリダイレクトする" do
        expect(response).to redirect_to root_path
      end

      it "フラッシュを返す" do
        expect(flash[:alert]).to eq "掲載者側でログアウトしてから利用者ログインをしてください。"
      end
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      let(:params) { { email: user.email, password: user.password } }

      before do
        post user_session_path, params: { user: params }
      end

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

      before do
        post user_session_path, params: { user: params }
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end

      it "フラッシュを返す" do
        expect(flash[:alert]).to eq "メールアドレスまたはパスワードが違います"
      end
    end

    context "オーナーでログインしている場合" do
      let(:params) { { email: user.email, password: user.password } }

      before do
        sign_in owner
        post user_session_path, params: { user: params }
      end

      it "root_pathにリダイレクトする" do
        expect(response).to redirect_to root_path
      end

      it "フラッシュを返す" do
        expect(flash[:alert]).to eq "掲載者側でログアウトしてから利用者ログインをしてください。"
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
