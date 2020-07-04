require 'rails_helper'

RSpec.describe "OwnerSignIn", type: :system do
  let(:owner) { create(:owner) }

  it "オーナーはログイン＆ログアウトできる" do
    visit root_path

    within("header") do
      click_link "オーナーログイン"
    end

    # エラーが表示されることを確認
    click_button "ログイン"
    expect(page).to have_content "メールアドレスまたはパスワードが違います"

    # ログインできることを確認
    fill_in "メールアドレス", with: owner.email
    fill_in "パスワード", with: owner.password
    click_button "ログイン"

    expect(page).to have_content "ログインしました"
    expect(current_path).to eq owners_path

    # ログアウトできることを確認
    within("header") do
      click_link "ログアウト"
    end

    expect(page).to have_content "ログアウトしました"
    expect(current_path).to eq root_path
  end
end
