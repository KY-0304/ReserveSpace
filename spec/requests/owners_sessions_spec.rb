require 'rails_helper'

RSpec.describe "OwnersSessions", type: :request do
  let(:owner) { create(:owner) }

  describe "GET #new" do
    it "ステータスコード200を返す" do
      get new_owner_session_path
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    before do
      post owner_session_path, params: { owner: params }
    end

    context "パラメータが妥当な場合" do
      let(:params) { { email: owner.email, password: owner.password } }

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "owners_pathにリダイレクトする" do
        expect(response).to redirect_to owners_path
      end
    end

    context "パラメータが不正な場合" do
      let(:params) { { email: "", password: owner.password } }

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end

      it "エラー文を返す" do
        expect(response.body).to include "メールアドレスまたはパスワードが違います"
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in owner
      delete destroy_owner_session_path
    end

    it "ステータスコード302を返す" do
      expect(response.status).to eq 302
    end

    it "root_pathにリダイレクトする" do
      expect(response).to redirect_to root_path
    end
  end
end
