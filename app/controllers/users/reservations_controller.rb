class Users::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :reservation_user, only: :destroy

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
    @reservation.destroy!
    flash[:success] = "予約の削除が完了しました。"
    redirect_to root_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:room_id, :start_time, :end_time)
  end

  def reservation_user
    @reservation = current_user.reservations.find_by(id: params[:id])
    redirect_to users_reservations_path if @reservation&.user != current_user
  end
end
