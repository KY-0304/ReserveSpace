RSpec.describe Reservation, type: :model do
  describe "validation" do
    let(:user)  { create(:user) }
    let(:space) { create(:space) }
    let(:reservation) do
      build(:reservation, space: space,
                          user: user,
                          start_time: "2000-01-01 10:00:00".in_time_zone,
                          end_time: "2000-01-01 15:00:00".in_time_zone)
    end

    before { travel_to Time.zone.local(2000, 1, 1, 9) }

    after { travel_back }

    it "有効なファクトリを持つこと" do
      expect(reservation).to be_valid
    end

    it "space_idが無いと無効" do
      reservation.space_id = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "スペースを入力してください"
    end

    it "user_idが無いと無効" do
      reservation.user_id = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "利用者を入力してください"
    end

    it "開始時間が無いと無効" do
      reservation.start_time = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間を入力してください"
    end

    it "終了時間が無いと無効" do
      reservation.end_time = nil
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間を入力してください"
    end

    it "営業時間外だと無効" do
      space.business_start_time = "11:00:00"
      space.business_end_time   = "14:00:00"
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間は11:00以降にしてください。"
      expect(reservation.errors.full_messages).to include "終了時間は14:00以前にしてください。"
    end

    it "利用時間が１時間未満だと無効" do
      reservation.start_time = "2000-01-01 10:00:00".in_time_zone
      reservation.end_time   = "2000-01-01 10:59:00".in_time_zone
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間は11:00以降にしてください。"
    end

    it "15分単位の予約時間でないと無効" do
      reservation.start_time = "2000-01-01 10:01:00".in_time_zone
      reservation.end_time   = "2000-01-01 11:01:00".in_time_zone
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間は15分単位で設定してください"
      expect(reservation.errors.full_messages).to include "終了時間は15分単位で設定してください"
    end

    it "終了時間が開始時間より前だと無効" do
      reservation.end_time = "2000-01-01 09:59:00".in_time_zone
      reservation.valid?
      expect(reservation.errors.full_messages).to include "終了時間は2000-01-01 10:00より後にしてください。"
    end

    it "開始時間が過去の日時だと無効" do
      reservation.start_time = "2000-01-01 08:00:00".in_time_zone
      reservation.valid?
      expect(reservation.errors.full_messages).to include "開始時間は2000-01-01 09:00以降にしてください。"
    end

    context "日付を跨がる場合" do
      it "終了日が、開始日の翌日なら有効" do
        reservation.end_time = "2000-01-02 15:00:00".in_time_zone
        expect(reservation).to be_valid
      end

      it "終了日が、開始日の明後日以降は無効" do
        reservation.end_time = "2000-01-03 15:00:00".in_time_zone
        reservation.valid?
        expect(reservation.errors.full_messages).to include "終了時間は、開始日時と同じ日付、もしくは翌日にしてください。"
      end
    end

    context "予約時間帯が被った場合" do
      let(:other_space) { create(:space) }
      let(:other_reservation) do
        build(:reservation, space: space,
                            start_time: "2000-01-01 11:00:00".in_time_zone,
                            end_time: "2000-01-01 14:00:00".in_time_zone)
      end

      before do
        reservation.save
      end

      it "同じスペースだと無効" do
        other_reservation.valid?
        expect(other_reservation.errors.full_messages).to include "予約重複：既にある予約と被っています。"
      end

      it "違うスペースだと有効" do
        other_reservation.space_id = other_space.id
        expect(other_reservation).to be_valid
      end
    end

    context "スペースが予約受付拒否している場合" do
      before do
        space.reservation_unacceptable = true
      end

      context "期間指定の場合" do
        before do
          space.reservation_unacceptable_start_date = Date.parse("2000/01/02")
          space.reservation_unacceptable_end_date   = Date.parse("2000/01/04")
        end

        it "期間以外の予約日なら有効" do
          reservation.start_time = "2000-01-01 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-01 15:00:00".in_time_zone

          expect(reservation).to be_valid

          reservation.start_time = "2000-01-05 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-05 15:00:00".in_time_zone

          expect(reservation).to be_valid
        end

        it "期間内の予約日は無効" do
          reservation.start_time = "2000-01-02 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-02 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02から2000-01-04の期間は予約を受け付けておりません。"

          reservation.start_time = "2000-01-03 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-03 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02から2000-01-04の期間は予約を受け付けておりません。"

          reservation.start_time = "2000-01-04 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-04 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02から2000-01-04の期間は予約を受け付けておりません。"
        end
      end

      context "開始日のみ指定の場合" do
        before do
          space.reservation_unacceptable_start_date = Date.parse("2000/01/02")
          space.reservation_unacceptable_end_date   = nil
        end

        it "開始日以前の予約日なら有効" do
          reservation.start_time = "2000-01-01 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-01 15:00:00".in_time_zone

          expect(reservation).to be_valid
        end

        it "開始日以降の予約日は無効" do
          reservation.start_time = "2000-01-02 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-02 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02以降の予約を受け付けておりません。"

          reservation.start_time = "2000-02-01 10:00:00".in_time_zone
          reservation.end_time   = "2000-02-01 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02以降の予約を受け付けておりません。"
        end
      end

      context "終了日のみ指定の場合" do
        before do
          space.reservation_unacceptable_start_date = nil
          space.reservation_unacceptable_end_date   = Date.parse("2000/01/02")
        end

        it "終了日後の予約日は有効" do
          reservation.start_time = "2000-01-03 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-03 15:00:00".in_time_zone

          expect(reservation).to be_valid
        end

        it "終了日までの予約日は無効" do
          reservation.start_time = "2000-01-01 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-01 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02以前の予約を受け付けておりません。"

          reservation.start_time = "2000-01-02 10:00:00".in_time_zone
          reservation.end_time   = "2000-01-02 15:00:00".in_time_zone
          reservation.valid?

          expect(reservation.errors.full_messages).to include "現在、2000-01-02以前の予約を受け付けておりません。"
        end
      end

      context "期間の指定が無い場合" do
        before do
          space.reservation_unacceptable_start_date = nil
          space.reservation_unacceptable_end_date   = nil
        end

        it "すべての新規予約ができない" do
          rand_day = rand(0..10000).days
          reservation.start_time += rand_day
          reservation.end_time   += rand_day
          reservation.valid?
          expect(reservation.errors.full_messages).to include "現在、新規の予約を受け付けておりません。"
        end
      end
    end

    context "スペースが当日予約不可の設定をしている場合" do
      before do
        space.reject_same_day_reservation = true
      end

      it "当日予約ができない" do
        reservation.valid?
        expect(reservation.errors.full_messages).to include "当日の予約は受付できません。"
      end
    end

    context "スペースが予約日に予約受付可能日数を設けている場合" do
      let(:reservation) do
        build(:reservation, space: space,
                            user: user,
                            start_time: "2000-01-12 10:00:00".in_time_zone,
                            end_time: "2000-01-12 15:00:00".in_time_zone)
      end

      it "制限日より後の予約は無効" do
        space.accepted_until_day = 10
        reservation.valid?
        expect(reservation.errors.full_messages).to include "2000-01-11より後の予約は受け付けられません。"
      end
    end
  end
end
