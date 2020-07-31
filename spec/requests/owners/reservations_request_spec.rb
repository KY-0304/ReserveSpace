require 'rails_helper'

RSpec.describe "Owners::Reservations", type: :request do
  let(:owner) { create(:owner) }
  let(:space) { create(:space, owner: owner) }
  let(:reservation) { create(:reservation, space: space) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
        get owners_reservations_path
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get owners_reservations_path
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
