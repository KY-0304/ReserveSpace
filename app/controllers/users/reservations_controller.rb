class Users::ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations.includes(:space)
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      flash[:success] = "予約が完了しました"
      redirect_to space_path(@reservation.space)
    else
      @space = Space.includes(reviews: :user).find(params[:reservation][:space_id])
      @review = Review.new
      render 'spaces/show'
    end
  end

  def destroy
    current_user.reservations.find(params[:id]).destroy!
    flash[:success] = "予約の削除が完了しました。"
    redirect_to root_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:space_id, :start_time, :end_time)
  end
end
