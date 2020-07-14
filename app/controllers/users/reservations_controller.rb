class Users::ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      flash[:success] = "予約が完了しました"
      redirect_to root_path
    else
      @room = Room.find(params[:reservation][:room_id])
      @reservations = @room.reservations
      render 'rooms/show'
    end
  end

  def destroy
    @reservation = current_user.reservations.find_by(id: params[:id])
    unless @reservation
      flash[:warning] = "予約が見つかりませんでした"
      redirect_to root_path
      return
    end

    @reservation.destroy!
    flash[:success] = "予約の削除が完了しました。"
    redirect_to root_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:room_id, :start_time, :end_time)
  end
end
