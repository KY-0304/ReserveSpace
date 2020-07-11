require 'rails_helper'

RSpec.describe "UserSignIn", type: :system do
  let(:user) { create(:user) }

  it "ユーザーはログイン＆ログアウトできる" do
    visit root_path

    within("header") do
      click_link "ユーザーログイン"
    end

    # ログインできることを確認
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect(page).to have_content "ログインしました"
    expect(current_path).to eq root_path

    # ログアウトできることを確認
    within("header") do
      click_link "ログアウト"
    end

    expect(page).to have_content "ログアウトしました"
    expect(current_path).to eq root_path
  end
end
