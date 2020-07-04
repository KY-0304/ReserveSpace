require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { create(:room) }

  it "名前が無いと無効" do
    room.name = nil
    room.valid?
    expect(room.errors.full_messages).to include "名前を入力してください"
  end

  it "住所が無いと無効" do
    room.address = nil
    room.valid?
    expect(room.errors.full_messages).to include "住所を入力してください"
  end

  it "時間単価が無いと無効" do
    room.hourly_price = nil
    room.valid?
    expect(room.errors.full_messages).to include "時間単価を入力してください"
  end

  it "営業開始時間が無いと無効" do
    room.business_start_time = nil
    room.valid?
    expect(room.errors.full_messages).to include "営業開始時間を入力してください"
  end

  it "営業終了時間が無いと無効" do
    room.business_end_time = nil
    room.valid?
    expect(room.errors.full_messages).to include "営業終了時間を入力してください"
  end
end
