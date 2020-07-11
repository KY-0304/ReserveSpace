require 'rails_helper'

RSpec.describe "UserSignUp", type: :system do
  it "ユーザーはアカウント登録＆削除ができる" do
    visit root_path

    within("header") do
      click_link "ユーザーログイン"
    end
    click_link "アカウント登録はこちら"

    # ユーザーが登録されることを確認
    expect do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "名前", with: "test_name"
      fill_in "連絡先", with: "080-1234-1234"
      select "男性", from: "性別"
      fill_in "パスワード", with: "password"
      fill_in "確認用パスワード", with: "password"
      click_button "登録"
    end.to change(User, :count).by 1

    expect(page).to have_content "ようこそ！ アカウントが登録されました"
    expect(current_path).to eq root_path

    within("header") do
      click_link "登録情報編集"
    end

    # ユーザーアカウントが削除されることの確認
    expect do
      click_link "アカウント削除"
    end.to change(User, :count).by(-1)

    expect(page).to have_content "ご利用ありがとうございました。アカウントが削除されました。またのご利用をお待ちしています"
    expect(current_path).to eq root_path
  end
end
