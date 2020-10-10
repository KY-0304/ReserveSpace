RSpec.describe "UsersPasswords", type: :request do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "ステータスコード200を返す" do
      get new_user_password_path
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    before do
      post user_password_path, params: { user: params }
    end

    context "パラメータが妥当な場合" do
      let(:params) { { email: user.email } }

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end

      it "フラッシュを返す" do
        expect(flash[:notice]).to eq "パスワードのリセット方法を数分以内にメールでご連絡します"
      end
    end

    context "パラメータが不正な場合" do
      let(:params) { { email: "invalid@example.com" } }

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end

      it "エラー文を返す" do
        expect(response.body).to include "メールアドレスは見つかりませんでした"
      end
    end

    context "パラメータがブランクの場合" do
      let(:params) { { email: "" } }

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end

      it "エラー文を返す" do
        expect(response.body).to include "メールアドレスを入力してください"
      end
    end
  end

  describe "GET #edit" do
    context "トークンがある場合" do
      let(:params) { { reset_password_token: user.send_reset_password_instructions } }

      it "ステータスコード200を返す" do
        get edit_user_password_path, params: params
        expect(response.status).to eq 200
      end
    end

    context "トークンが無い場合" do
      before do
        get edit_user_password_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PUT #update" do
    context "トークンが妥当な場合" do
      let(:token) { user.send_reset_password_instructions }

      before do
        put user_password_path, params: { user: params }
      end

      context "パスワードが妥当な場合" do
        let(:params) { { password: "123456", password_confirmation: "123456", reset_password_token: token } }

        it "ステータスコード302を返す" do
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          expect(response).to redirect_to root_path
        end

        it "フラッシュを返す" do
          expect(flash[:notice]).to eq "パスワードを変更しました。ログイン済みです"
        end
      end

      context "パスワードが不正な場合" do
        let(:params) { { password: "123", password_confirmation: "123", reset_password_token: token } }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "パスワードは6文字以上で入力してください"
        end
      end

      context "パスワードが一致しない場合" do
        let(:params) { { password: "123456", password_confirmation: "654321", reset_password_token: token } }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "確認用パスワードとパスワードの入力が一致しません"
        end
      end

      context "パスワードがブランクの場合" do
        let(:params) { { password: "", password_confirmation: "", reset_password_token: token } }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "パスワードを入力してください"
        end
      end
    end

    context "トークンが不正な場合" do
      let(:params) { { password: "123456", password_confirmation: "123456", reset_password_token: "invalid" } }

      before do
        user.send_reset_password_instructions
        put user_password_path, params: { user: params }
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end

      it "エラー文を返す" do
        expect(response.body).to include "パスワードリセット用トークンは不正な値です"
      end
    end
  end
end
