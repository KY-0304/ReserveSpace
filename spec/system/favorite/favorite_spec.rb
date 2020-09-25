require 'rails_helper'

RSpec.describe "Favorite", type: :system do
  let(:user)  { create(:user) }
  let(:space) { create(:space) }

  it "ユーザーはスペースをお気に入り登録＆削除できる", js: true do
    sign_in user
    visit space_path(space)

    # お気に入り登録できることの確認
    within "#favorite" do
      expect(page).to have_selector "h4", text: "お気に入り"
      expect(page).to have_selector "p", text: "0人がお気に入り登録してます"

      expect do
        click_button "お気に入り登録"
        expect(page).to have_selector "button", text: "お気に入り削除"
      end.to change(user.favorites, :count).by 1
    end

    # お気に入り一覧に反映されていることの確認
    within "header" do
      click_link "お気に入り"
    end

    expect(current_path).to eq users_favorites_path

    within "#space-#{space.id}" do
      click_on space.name
    end

    expect(current_path).to eq space_path(space)

    # お気に入り削除できることの確認
    within "#favorite" do
      expect(page).to have_selector "p", text: "1人がお気に入り登録してます"

      expect do
        click_button "お気に入り削除"
        expect(page).to have_selector "button", text: "お気に入り登録"
      end.to change(user.favorites, :count).by(-1)
    end
  end
end
