require 'rails_helper'

RSpec.describe Setting, type: :model do
  let(:space)     { create(:space) }
  let(:start_day) { Date.parse("2000/1/1") }
  let(:end_day)   { Date.parse("2000/1/2") }
  let(:setting) do
    build(:setting, space: space,
                    date_range_reservation_unacceptable: true,
                    reservation_unacceptable_start_day: start_day,
                    reservation_unacceptable_end_day: end_day)
  end

  before { travel_to Time.zone.local(2000, 1, 1) }

  after { travel_back }

  it "有効なファクトリを持つこと" do
    expect(setting).to be_valid
  end

  it "予約受付拒否(日付範囲)がnilだと無効" do
    setting.date_range_reservation_unacceptable = nil
    setting.valid?
    expect(setting.errors.full_messages).to include "予約受付拒否(日付範囲)は不正な値です。"
  end

  context "予約受付拒否(日付範囲)がtrueの場合" do
    before do
      setting.date_range_reservation_unacceptable = true
    end

    it "予約受付拒否終了日が開始日より前だと無効" do
      setting.reservation_unacceptable_start_day = end_day
      setting.reservation_unacceptable_end_day   = start_day
      setting.valid?
      expect(setting.errors.full_messages).to include "予約受付拒否終了日は2000-01-02 00:00より後にしてください。"
    end

    it "予約受付拒否開始日時が現在より前の日時だと無効" do
      setting.reservation_unacceptable_start_day = Date.parse("1999/12/31")
      setting.valid?
      expect(setting.errors.full_messages).to include "予約受付拒否開始日は2000-01-01 00:00以降にしてください。"
    end
  end

  context "予約受付拒否(日付範囲)がfalseの場合" do
    before do
      setting.date_range_reservation_unacceptable = false
    end

    it "予約受付拒否開始日と終了日に関わるバリデーションをしない" do
      setting.reservation_unacceptable_start_day = end_day
      setting.reservation_unacceptable_end_day   = start_day
      expect(setting).to be_valid
    end
  end
end
