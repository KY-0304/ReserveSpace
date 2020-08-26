class Users::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:new, :create]

  def index
    @reservations = current_user.reservations.includes(:space).order(start_time: :desc).page(params[:page]).per(10)
  end

  def new
    render_spaces_show unless @reservation.valid?
  end

  def create
    return render_spaces_show if params[:back].present?

    if @reservation.save
      redirect_to space_path(@reservation.space), notice: "予約が完了しました"
    else
      render_spaces_show
    end
  end

  def destroy
    current_user.reservations.find(params[:id]).destroy!
    redirect_to root_path, notice: "予約の削除が完了しました。"
  end

  private

  def reservation_params
    params.require(:reservation).permit(:space_id, :start_time, :end_time)
  end

  def set_reservation
    @reservation = current_user.reservations.build(reservation_params)
  end

  def render_spaces_show
    @space = Space.includes(reviews: :user).find(params[:reservation][:space_id])
    @review = Review.new
    render 'spaces/show'
  end
end
