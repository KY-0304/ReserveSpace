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

  describe "POST#search" do
    context "ログインしている場合" do
      before do
        sign_in owner
      end

      context "format.htmlの場合" do
        it "ステータスコード200を返す" do
          post search_space_reservations_path(space)
          expect(response.status).to eq 200
        end
      end

      context "format.csvの場合" do
        let!(:reservation) { create(:reservation, :skip_validate, space: space, start_time: Time.current, end_time: Time.current + 1.hour) }

        before do
          post search_space_reservations_path(space, format: :csv)
        end

        it "csvを返す" do
          expect(response.header["Content-Type"]).to eq "text/csv"
        end

        it "予約一覧のcsvを返す" do
          csv    = CSV.parse(response.body, headers: true)
          header = ["利用日", "利用時間", "料金", "利用者名", "連絡先", "性別"]

          expect(csv.headers).to eq header
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post search_space_reservations_path(space)
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
