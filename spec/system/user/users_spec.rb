RSpec.describe "Users", type: :system do
  let(:user) do
    create(:user, email: "test@example.com",
                  name: "test_name",
                  phone_number: "080-1234-1234",
                  password: "password",
                  password_confirmation: "password")
  end

  it "利用者は登録情報を編集できる" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_no_content "性別"

    # 現在のパスワードダイジェストを変数に格納
    current_encrypted_password = user.encrypted_password

    fill_in "メールアドレス", with: "change@example.com"
    fill_in "名前", with: "change_name"
    fill_in "連絡先", with: "050-1234-1234"
    fill_in "パスワード", with: "new_password"
    fill_in "確認用パスワード", with: "new_password"
    fill_in "現在のパスワード", with: user.password
    click_button "変更"

    user.reload

    expect(page).to have_content "アカウントが更新されました"
    expect(user.email).to eq "change@example.com"
    expect(user.name).to eq "change_name"
    expect(user.phone_number).to eq "050-1234-1234"
    expect(user.encrypted_password).not_to eq current_encrypted_password
    expect(current_path).to eq root_path
  end
end
