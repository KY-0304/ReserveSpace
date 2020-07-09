require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  let(:owner) { create(:owner) }
  let!(:room) do
    create(:room, owner: owner,
                  name: "test会議室",
                  description: "説明",
                  address: "東京都港区三田1-1-1",
                  phone_number: "03-1111-1111",
                  hourly_price: 500,
                  business_start_time: "9:00",
                  business_end_time: "21:00")
  end
  let(:other_owner) { create(:owner) }

  before do
    sign_in owner
    visit rooms_path
  end

  it "オーナーは会議室を登録&削除できる" do
    click_link "会議室登録"

    # 会議室が登録されることの確認
    expect do
      fill_in "名前", with: "テスト会議室"
      fill_in "説明", with: "テスト説明"
      attach_file "イメージ", "#{Rails.root}/public/images/room.jpg"
      fill_in "住所", with: "東京都港区三田1-1-1"
      fill_in "連絡先", with: "03-1234-1234"
      fill_in "時間単価", with: "1000"
      fill_in "営業開始時間", with: "09:00"
      fill_in "営業終了時間", with: "20:00"
      click_button "登録"
    end.to change(Room, :count).by 1

    expect(current_path).to eq rooms_path
    expect(page).to have_content "会議室の登録を完了しました"

    # 会議室が削除されることの確認
    click_link "テスト会議室"
    click_link "編集"
    expect do
      click_link "会議室削除"
    end.to change(Room, :count).by(-1)

    expect(current_path).to eq rooms_path
    expect(page).to have_content "会議室の削除が完了しました"
  end

  it "オーナーは会議室を編集できる" do
    click_link room.name
    click_link "編集"

    fill_in "名前", with: "アップデート会議室"
    fill_in "説明", with: "アップデート説明"
    attach_file "イメージ", "#{Rails.root}/public/images/room.jpg"
    fill_in "住所", with: "東京都港区三田2-2-2"
    fill_in "連絡先", with: "080-1111-1111"
    fill_in "時間単価", with: "1000"
    fill_in "営業開始時間", with: "07:00"
    fill_in "営業終了時間", with: "20:00"
    click_button "変更"

    room.reload

    expect(current_path).to eq rooms_path
    expect(page).to have_content "会議室の編集が完了しました"
    expect(room.name).to eq "アップデート会議室"
    expect(room.description).to eq "アップデート説明"
    expect(room.image.url).to eq "/uploads_test/room/image/#{room.id}/room.jpg"
    expect(room.address).to eq "東京都港区三田2-2-2"
    expect(room.phone_number).to eq "080-1111-1111"
    expect(room.hourly_price).to eq "1000"
    expect(room.business_start_time.strftime("%H:%M")).to eq "07:00"
    expect(room.business_end_time.strftime("%H:%M")).to eq "20:00"
  end
end
