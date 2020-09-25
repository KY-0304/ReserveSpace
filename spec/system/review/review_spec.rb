require 'rails_helper'

RSpec.describe "Reservation", type: :system do
  let(:user)         { create(:user) }
  let(:space)        { create(:space) }
  let!(:reservation) { create(:reservation, :skip_validate, user: user, space: space, end_time: Time.current - 1.hour) }

  it "ユーザーは利用したことのあるスペースにレビューを投稿＆削除できる", js: true do
    sign_in user
    visit space_path(space)
    click_link "レビュー"

    # レビューが投稿できることの確認
    within "#review-form" do
      select "良い", from: "review_rate"
      fill_in "コメント", with: "良いスペースでした"

      expect do
        click_button "投稿"
        sleep 0.5
      end.to change(user.reviews, :count).by 1
    end

    review = user.reviews.first

    # レビューが投稿されたことの確認、削除できることの確認
    within "#review-#{review.id}" do
      expect(page).to have_content "評価: 良い"
      expect(page).to have_content review.comment
      expect(page).to have_content I18n.l(review.created_at)

      expect do
        click_link "削除"
        expect(page.accept_confirm).to eq "削除しますか？"
        sleep 0.5
      end.to change(user.reviews, :count).by(-1)
    end

    expect(page).not_to have_selector "#review-#{review.id}"
  end
end
