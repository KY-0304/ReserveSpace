require 'rails_helper'

RSpec.describe "Spaces", type: :system do
  let(:owner) { create(:owner) }
  let!(:space) do
    create(:space, owner: owner,
                   name: "testスペース",
                   description: "説明",
                   phone_number: "03-1111-1111",
                   hourly_price: 500,
                   capacity: 20,
                   business_start_time: "9:00",
                   business_end_time: "21:00")
  end
  let(:other_owner) { create(:owner) }

  before do
    sign_in owner
    visit spaces_path
  end

  it "掲載者はスペースを登録&削除できる", js: true do
    click_link "スペース登録"

    # スペースが登録されることの確認
    fill_in "名前", with: "テストスペース"
    fill_in "説明", with: "テスト説明"
    attach_file "イメージ", "#{Rails.root}/public/images/space.jpg"
    fill_in "郵便番号", with: "1080073"
    expect(page).to have_select "都道府県", selected: "東京都"
    expect(page).to have_field "市区町村", with: "港区"
    expect(page).to have_field "番地", with: "三田"
    fill_in "建物", with: "テストビル"
    fill_in "連絡先", with: "03-1234-1234"
    fill_in "時間単価", with: "1000"
    fill_in "収容人数", with: "30"
    select "09", from: "space_business_start_time_4i"
    select "00", from: "space_business_start_time_5i"
    select "20", from: "space_business_end_time_4i"
    select "00", from: "space_business_end_time_5i"
    expect do
      click_button "登録"
      expect(page).to have_content "スペースの登録を完了しました"
    end.to change(Space, :count).by 1

    expect(current_path).to eq spaces_path

    # スペースが削除されることの確認
    within "#space-#{Space.last.id}" do
      click_link "編集"
    end
    expect do
      click_link "スペース削除"
      expect(page.accept_confirm).to eq "スペースを削除します。本当によろしいでしょうか。"
      expect(page).to have_content "スペースの削除が完了しました"
    end.to change(Space, :count).by(-1)

    expect(current_path).to eq spaces_path
  end

  it "掲載者はスペースを編集できる" do
    within "#space-#{space.id}" do
      click_link "編集"
    end

    fill_in "名前", with: "アップデートスペース"
    fill_in "説明", with: "アップデート説明"
    attach_file "イメージ", "#{Rails.root}/public/images/space.jpg"
    fill_in "連絡先", with: "080-1111-1111"
    fill_in "時間単価", with: "1000"
    fill_in "収容人数", with: "30"
    select "07", from: "space_business_start_time_4i"
    select "00", from: "space_business_start_time_5i"
    select "20", from: "space_business_end_time_4i"
    select "00", from: "space_business_end_time_5i"
    click_button "変更"

    space.reload

    expect(current_path).to eq spaces_path
    expect(page).to have_content "スペースの編集が完了しました"
    expect(space.name).to eq "アップデートスペース"
    expect(space.description).to eq "アップデート説明"
    expect(space.images[0].url).to eq "/uploads_test/space/images/#{space.id}/space.jpg"
    expect(space.phone_number).to eq "080-1111-1111"
    expect(space.hourly_price).to eq 1000
    expect(space.capacity).to eq 30
    expect(space.business_start_time.strftime("%H:%M")).to eq "07:00"
    expect(space.business_end_time.strftime("%H:%M")).to eq "20:00"
  end
end
