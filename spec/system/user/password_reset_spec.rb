require 'rails_helper'

RSpec.describe "UserResetPassword", type: :system do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  it "ユーザーはパスワードをリセットすることができる" do
    # 送信メールのリセット
    ActionMailer::Base.deliveries.clear

    visit root_path

    within("header") do
      click_link "ユーザーログイン"
    end
    click_link "パスワードを忘れた方はこちら"

    fill_in "メールアドレス", with: user.email
    click_button "メール送信"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "パスワードのリセット方法を数分以内にメールでご連絡します"

    # メールが１件送られていることの確認
    expect(ActionMailer::Base.deliveries.size).to eq 1

    # 送信したメールのリンクを取得する
    mail = ActionMailer::Base.deliveries.first
    body = mail.body.encoded
    url = body[/http[^"]+/]

    visit url

    # 現在のパスワードダイジェストを変数に格納
    current_encrypted_password = user.encrypted_password

    fill_in "パスワード", with: "new_password"
    fill_in "確認用パスワード", with: "new_password"
    click_button "パスワード再設定"

    # パスワードが変更されることを確認
    user.reload

    expect(page).to have_content "パスワードを変更しました。ログイン済みです"
    expect(current_path).to eq root_path
    expect(user.encrypted_password).not_to eq current_encrypted_password
  end
end
