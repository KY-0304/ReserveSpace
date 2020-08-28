require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:owner) { create(:owner) }
  let(:space) { create(:space, owner: owner) }

  describe "GET#index" do
    context "ログインしている場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get space_reservations_path(space)
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get space_reservations_path(space)
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "GET#search" do
    context "ログインしている場合" do
      before do
        sign_in owner
      end

      it "ステータスコード200を返す" do
        get search_space_reservations_path(space)
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get search_space_reservations_path(space)
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
