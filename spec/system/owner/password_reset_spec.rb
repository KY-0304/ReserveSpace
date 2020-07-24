require 'rails_helper'

RSpec.describe "OwnerResetPassword", type: :system do
  let(:owner) { create(:owner, password: "password", password_confirmation: "password") }

  it "掲載者はパスワードをリセットすることができる" do
    # 送信メールのリセット
    ActionMailer::Base.deliveries.clear

    visit root_path

    within("header") do
      click_link "掲載者ログイン"
    end
    click_link "パスワードを忘れた方はこちら"

    fill_in "メールアドレス", with: owner.email
    click_button "メール送信"

    expect(current_path).to eq new_owner_session_path
    expect(page).to have_content "パスワードのリセット方法を数分以内にメールでご連絡します"

    # メールが１件送られていることの確認
    expect(ActionMailer::Base.deliveries.size).to eq 1

    # 送信したメールのリンクを取得する
    mail = ActionMailer::Base.deliveries.first
    body = mail.body.encoded
    url = body[/http[^"]+/]

    visit url

    # 現在のパスワードダイジェストを変数に格納
    current_encrypted_password = owner.encrypted_password

    fill_in "パスワード", with: "new_password"
    fill_in "確認用パスワード", with: "new_password"
    click_button "パスワード再設定"

    # パスワードが変更されることを確認
    owner.reload

    expect(page).to have_content "パスワードを変更しました。ログイン済みです"
    expect(current_path).to eq rooms_path
    expect(owner.encrypted_password).not_to eq current_encrypted_password
  end
end
