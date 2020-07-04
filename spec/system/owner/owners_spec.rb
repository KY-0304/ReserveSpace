require 'rails_helper'

RSpec.describe "Owners", type: :system do
  let(:owner) do
    create(:owner, email: "test@example.com",
                   company_name: "test_company",
                   password: "password",
                   password_confirmation: "password")
  end

  it "オーナーは登録情報を編集できる" do
    sign_in owner
    visit edit_owner_registration_path

    # エラーが表示されることを確認
    click_button "変更"
    expect(page).to have_content "現在のパスワードを入力してください"

    # 現在のパスワードダイジェストを変数に格納
    current_encrypted_password = owner.encrypted_password

    # 登録情報が変更されることを確認
    fill_in "メールアドレス", with: "change@example.com"
    fill_in "会社名", with: "change_company"
    fill_in "パスワード", with: "new_password"
    fill_in "確認用パスワード", with: "new_password"
    fill_in "現在のパスワード", with: owner.password
    click_button "変更"

    owner.reload
    aggregate_failures do
      expect(page).to have_content "アカウントが更新されました"
      expect(owner.email).to eq "change@example.com"
      expect(owner.company_name).to eq "change_company"
      expect(owner.encrypted_password).not_to eq current_encrypted_password
    end
  end
end
