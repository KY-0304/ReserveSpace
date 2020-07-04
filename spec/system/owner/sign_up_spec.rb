require 'rails_helper'

RSpec.describe "OwnerSignUp", type: :system do
  it "オーナーはアカウント登録＆削除ができる" do
    visit root_path

    within("header") do
      click_link "オーナーログイン"
    end
    click_link "オーナー登録はこちら"

    # エラーが表示されることを確認
    fill_in "パスワード", with: "pass"
    fill_in "確認用パスワード", with: "password"
    click_button "登録"

    aggregate_failures do
      expect(page).to have_content "メールアドレスを入力してください"
      expect(page).to have_content "パスワードは6文字以上で入力してください"
      expect(page).to have_content "確認用パスワードとパスワードの入力が一致しません"
      expect(page).to have_content "会社名を入力してください"
    end

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
  end
end
