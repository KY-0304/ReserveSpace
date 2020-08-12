require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user) }
  let(:space) { create(:space) }

  describe "POST #create" do
    let(:params) { { user: user, space_id: space.id, rate: :very_good, comment: "テストコメント" } }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          post space_reviews_path(space), params: { review: params }
          expect(response.status).to eq 302
        end

        it "space_pathにリダイレクトする" do
          post space_reviews_path(space), params: { review: params }
          expect(response).to redirect_to space_path(space)
        end

        it "reviewが登録される" do
          expect do
            post space_reviews_path(space), params: { review: params }
          end.to change(space.reviews, :count).by 1
        end

        it "フラッシュを返す" do
          post space_reviews_path(space), params: { review: params }
          expect(flash[:notice]).to eq "レビューを投稿しました"
        end
      end

      context "パラメータが不正な場合" do
        let(:invalid_params) { { user: user, space: space, rate: "", comment: "" } }

        it "ステータスコード200を返す" do
          post space_reviews_path(space), params: { review: invalid_params }
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          post space_reviews_path(space), params: { review: invalid_params }
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "reviewが登録されない" do
          expect do
            post space_reviews_path(space), params: { review: invalid_params }
          end.not_to change(space.reviews, :count)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        post space_reviews_path(space), params: { review: params }
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
    let!(:review) { create(:review, user: user, space: space) }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "ステータスコード302を返す" do
        delete review_path(review)
        expect(response.status).to eq 302
      end

      it "space_pathにリダイレクトする" do
        delete review_path(review)
        expect(response).to redirect_to space_path(space)
      end

      it "reviewが削除される" do
        expect do
          delete review_path(review)
        end.to change(space.reviews, :count).by(-1)
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
