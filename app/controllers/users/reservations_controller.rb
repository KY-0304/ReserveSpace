class Users::ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      flash[:success] = "予約が完了しました"
      redirect_to room_path(@reservation.room)
    else
      @room = Room.includes(reviews: :user).find(params[:reservation][:room_id])
      @review = Review.new
      render 'rooms/show'
    end
  end

  def destroy
    current_user.reservations.find(params[:id]).destroy!
    flash[:success] = "予約の削除が完了しました。"
    redirect_to root_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:room_id, :start_time, :end_time)
  end
end
