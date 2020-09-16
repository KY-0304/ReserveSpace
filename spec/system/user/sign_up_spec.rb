require 'rails_helper'

RSpec.describe "UserSignUp", type: :system do
  it "利用者はアカウント登録＆削除ができる" do
    visit root_path

    within("header") do
      click_link "利用者登録"
    end

    # 利用者が登録されることを確認
    expect do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "名前", with: "test_name"
      fill_in "連絡先", with: "080-1234-1234"
      select "男性", from: "性別"
      fill_in "パスワード", with: "password"
      fill_in "確認用パスワード", with: "password"
      check "利用規約に同意する"
      click_button "登録"
    end.to change(User, :count).by 1

    expect(page).to have_content "ようこそ！ アカウントが登録されました"
    expect(current_path).to eq root_path

    within("header") do
      click_link "アカウント編集"
    end

    # 利用者アカウントが削除されることの確認
    expect do
      click_link "退会"
    end.to change(User, :count).by(-1)

    expect(page).to have_content "ご利用ありがとうございました。アカウントが削除されました。またのご利用をお待ちしています"
    expect(current_path).to eq root_path
  end
end
