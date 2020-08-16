require 'rails_helper'

RSpec.describe Setting, type: :model do
  let(:space)      { create(:space) }
  let(:start_time) { "2000-01-01 00:00:00".in_time_zone }
  let(:end_time)   { "2000-01-02 00:00:00".in_time_zone }
  let(:setting) do
    build(:setting, space: space, unacceptable: true, unacceptable_start_time: start_time, unacceptable_end_time: end_time)
  end

  before { travel_to Time.zone.local(2000, 1, 1) }

  after { travel_back }

  it "有効なファクトリを持つこと" do
    expect(setting).to be_valid
  end

  it "予約受付拒否終了日時が開始日時より前だと無効" do
    setting.unacceptable_start_time = end_time
    setting.unacceptable_end_time = start_time
    setting.valid?
    expect(setting.errors.full_messages).to include "予約受付拒否終了日時は2000-01-02 00:00より後にしてください。"
  end

  it "予約受付拒否開始日時が現在より前の日時だと無効" do
    setting.unacceptable_start_time = "1999-12-31 23:59:59".in_time_zone
    setting.valid?
    expect(setting.errors.full_messages).to include "予約受付拒否開始日時は2000-01-01 00:00以降にしてください。"
  end
end
