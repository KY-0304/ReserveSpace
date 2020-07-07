require 'rails_helper'

RSpec.describe "OwnerSignUp", type: :system do
  it "オーナーはアカウント登録＆削除ができる" do
    visit root_path

    within("header") do
      click_link "オーナーログイン"
    end
    click_link "オーナー登録はこちら"

    # オーナーが登録されることを確認
    expect do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "会社名", with: "test_company"
      fill_in "パスワード", with: "password"
      fill_in "確認用パスワード", with: "password"
      click_button "登録"
    end.to change(Owner, :count).by 1

    expect(page).to have_content "ようこそ！ アカウントが登録されました"
    expect(current_path).to eq owners_path

    within("header") do
      click_link "登録情報編集"
    end

    # オーナーアカウントが削除されることの確認
    expect do
      click_link "アカウント削除"
    end.to change(Owner, :count).by(-1)

    expect(page).to have_content "ご利用ありがとうございました。アカウントが削除されました。またのご利用をお待ちしています"
    expect(current_path).to eq root_path
  end
end
