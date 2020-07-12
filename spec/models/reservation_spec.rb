require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "validation" do
    let(:reservation) { create(:reservation) }

    it "有効なファクトリを持つこと" do
      expect(reservation).to be_valid
    end

    it "room_idが無いと無効" do
      reservation.room_id = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "会議室を入力してください"
    end

    it "user_idが無いと無効" do
      reservation.user_id = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "ユーザーを入力してください"
    end

    it "開始時間が無いと無効" do
      reservation.start_time = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間を入力してください"
    end

    it "同じ開始時間だと無効" do
      other_reservation = reservation.dup
      other_reservation.valid?
      expect(other_reservation.errors.full_messages).to include "開始時間はすでに存在します"
    end

    it "終了時間が無いと無効" do
      reservation.end_time = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間を入力してください"
    end

    it "同じ終了時間だと無効" do
      other_reservation = reservation.dup
      other_reservation.valid?
      expect(other_reservation.errors.full_messages).to include "終了時間はすでに存在します"
    end
  end
end
