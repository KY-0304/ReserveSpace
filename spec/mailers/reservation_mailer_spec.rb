RSpec.describe ReservationMailer, type: :mailer do
  describe "complete" do
    let(:space) { create(:space, name: "ReserveSpace会議室", hourly_price: 1000) }
    let(:user)  { create(:user, email: "user@example.com", name: "山田太郎") }
    let(:reservation) do
      create(:reservation, :skip_validate, user: user,
                                           space: space,
                                           start_time: "2000-01-01 10:00:00".in_time_zone,
                                           end_time: "2000-01-01 12:00:00".in_time_zone)
    end
    let(:mail) { ReservationMailer.with(user: user, reservation: reservation).complete }

    it "ユーザーのメールアドレスに送信すること" do
      expect(mail.to).to eq ["user@example.com"]
    end

    it "サポート用メールアドレスから送信されていること" do
      expect(mail.from).to eq ["reserve_space@example.com"]
    end

    it "件名が正しいこと" do
      expect(mail.subject).to eq "ご予約が確定致しました"
    end
  end

  describe "cancel" do
    let(:space) { create(:space, name: "ReserveSpace会議室", hourly_price: 1000) }
    let(:user)  { create(:user, email: "user@example.com", name: "山田太郎") }
    let(:reservation) do
      create(:reservation, :skip_validate, user: user,
                                           space: space,
                                           start_time: "2000-01-01 10:00:00".in_time_zone,
                                           end_time: "2000-01-01 12:00:00".in_time_zone)
    end
    let(:mail) { ReservationMailer.with(user: user, reservation: reservation).cancel }

    it "ユーザーのメールアドレスに送信すること" do
      expect(mail.to).to eq ["user@example.com"]
    end

    it "サポート用メールアドレスから送信されていること" do
      expect(mail.from).to eq ["reserve_space@example.com"]
    end

    it "件名が正しいこと" do
      expect(mail.subject).to eq "ご予約をキャンセル致しました"
    end
  end
end
