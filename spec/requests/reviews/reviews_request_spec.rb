require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  describe "POST #create" do
    let(:params) { { user: user, room_id: room.id, rate: 3, comment: "テストコメント" } }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          post room_reviews_path(room), params: { review: params }
          expect(response.status).to eq 302
        end

        it "room_pathにリダイレクトする" do
          post room_reviews_path(room), params: { review: params }
          expect(response).to redirect_to room_path(room)
        end

        it "reviewが登録される" do
          expect do
            post room_reviews_path(room), params: { review: params }
          end.to change(room.reviews, :count).by 1
        end

        it "フラッシュを返す" do
          post room_reviews_path(room), params: { review: params }
          expect(flash[:success]).to eq "レビューを投稿しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:invalid_params) { { user: user, room: room, rate: 0, comment: "テストコメント" } }

        it "ステータスコード200を返す" do
          post room_reviews_path(room), params: { review: invalid_params }
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          post room_reviews_path(room), params: { review: invalid_params }
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "reviewが登録されない" do
          expect do
            post room_reviews_path(room), params: { review: invalid_params }
          end.not_to change(room.reviews, :count)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post room_reviews_path(room), params: { review: params }
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
    let!(:review) { create(:review, user: user, room: room) }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "ステータスコード302を返す" do
        delete review_path(review)
        expect(response.status).to eq 302
      end

      it "room_pathにリダイレクトする" do
        delete review_path(review)
        expect(response).to redirect_to room_path(room)
      end

      it "reviewが削除される" do
        expect do
          delete review_path(review)
        end.to change(room.reviews, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      before do
        delete review_path(review)
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
