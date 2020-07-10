require 'rails_helper'

RSpec.describe "OwnerSignIn", type: :system do
  let(:owner) { create(:owner) }

  it "オーナーはログイン＆ログアウトできる" do
    visit root_path

    within("header") do
      click_link "オーナーログイン"
    end

    # ログインできることを確認
    fill_in "メールアドレス", with: owner.email
    fill_in "パスワード", with: owner.password
    click_button "ログイン"

    expect(page).to have_content "ログインしました"
    expect(current_path).to eq rooms_path

    # ログアウトできることを確認
    within("header") do
      click_link "ログアウト"
    end

    expect(page).to have_content "ログアウトしました"
    expect(current_path).to eq root_path
  end
end
