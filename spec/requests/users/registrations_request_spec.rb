require 'rails_helper'

RSpec.describe "UsersRegistrations", type: :request do
  let(:user) { create(:user, email: "test_email@example.com", name: "test_name") }

  describe "GET #new" do
    it "ステータスコード200を返す" do
      get new_user_registration_path
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      let(:user_params) { attributes_for(:user) }

      it "ステータスコード302を返す" do
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end

      it "root_pathにリダイレクトする" do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_path
      end

      it "userが登録される" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it "フラッシュを返す" do
        post user_registration_path, params: { user: user_params }
        expect(flash[:notice]).to eq "ようこそ！ アカウントが登録されました"
      end
    end

    context "パラメータが不正な場合" do
      let(:invalid_user_params) { attributes_for(:user, email: "", name: "", password: "") }

      it "ステータスコード200を返す" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end

      it "エラー文を返す" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include "以下のエラーが発生しました："
      end

      it "userが登録されない" do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end
    end
  end

  describe "GET #edit" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get edit_user_registration_path
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_user_registration_path
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
    let(:params) { { email: "hoge@example.com", name: "hoge", current_password: "password" } }

    context "ログイン済みの場合" do
      before do
        sign_in user
        put user_registration_path, params: { user: params }
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          expect(response).to redirect_to root_path
        end

        it "登録情報が更新される" do
          user.reload
          expect(user.name).to eq "hoge"
          expect(user.email).to eq "hoge@example.com"
        end

        it "フラッシュを返す" do
          expect(flash[:notice]).to eq "アカウントが更新されました"
        end
      end

      context "パラメータが不正な場合" do
        let(:params) { { name: "", current_password: "password" } }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "登録情報が更新されない" do
          user.reload
          expect(user.name).to eq "test_name"
        end
      end
    end

    context "ログインしていない場合" do
      before do
        put user_registration_path, params: { user: params }
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
    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      context "現在以降に予約がない場合" do
        let!(:reservation) { create(:reservation, :skip_validate, user: user, start_time: Time.current - 2.hours, end_time: Time.current - 1.hour) }

        it "ステータスコード302を返す" do
          delete user_registration_path
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          delete user_registration_path
          expect(response).to redirect_to root_path
        end

        it "利用者が削除される" do
          expect do
            delete user_registration_path
          end.to change(User, :count).by(-1)
        end

        it "フラッシュを返す" do
          delete user_registration_path
          expect(flash[:notice]).to eq "ご利用ありがとうございました。アカウントが削除されました。またのご利用をお待ちしています"
        end
      end

      context "現在以降に予約がある場合" do
        let!(:reservation) { create(:reservation, :skip_validate, user: user, start_time: Time.current + 1.hour, end_time: Time.current + 2.hours) }

        it "ステータスコード302を返す" do
          delete user_registration_path
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          delete user_registration_path
          expect(response).to redirect_to root_path
        end

        it "利用者が削除されない" do
          expect do
            delete user_registration_path
          end.not_to change(User, :count)
        end

        it "フラッシュを返す" do
          delete user_registration_path
          expect(flash[:alert]).to eq "完了していない予約がある為、アカウントを削除できません。"
        end
      end
    end

    context "ログインしていない場合" do
      it "ステータスコード302を返す" do
        delete user_registration_path
        expect(response.status).to eq 302
      end

      it "new_user_session_pathにリダイレクトする" do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end

      it "利用者は削除されない" do
        expect do
          delete user_registration_path
        end.not_to change(User, :count)
      end
    end
  end
end
