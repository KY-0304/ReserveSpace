require 'rails_helper'

RSpec.describe "Owners", type: :system do
  let(:owner) do
    create(:owner, email: "test@example.com",
                   company_name: "test_company",
                   password: "password",
                   password_confirmation: "password")
  end

  it "掲載者は登録情報を編集できる" do
    sign_in owner
    visit edit_owner_registration_path

    # 現在のパスワードダイジェストを変数に格納
    current_encrypted_password = owner.encrypted_password

    fill_in "メールアドレス", with: "change@example.com"
    fill_in "会社名", with: "change_company"
    fill_in "パスワード", with: "new_password"
    fill_in "確認用パスワード", with: "new_password"
    fill_in "現在のパスワード", with: owner.password
    click_button "変更"

    owner.reload

    expect(page).to have_content "アカウントが更新されました"
    expect(owner.email).to eq "change@example.com"
    expect(owner.company_name).to eq "change_company"
    expect(owner.encrypted_password).not_to eq current_encrypted_password
    expect(current_path).to eq root_path
  end
end
