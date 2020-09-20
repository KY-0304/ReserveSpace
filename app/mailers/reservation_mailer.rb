class ReservationMailer < ApplicationMailer
  def complete
    @user        = params[:user]
    @reservation = params[:reservation]

    mail(to: @user.email, subject: "ご予約が確定致しました")
  end

  def cancel
    @user        = params[:user]
    @reservation = params[:reservation]

    mail(to: @user.email, subject: "ご予約をキャンセル致しました")
  end
end
