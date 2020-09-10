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

    if params['payjp-token'].blank?
      flash[:alert] = "クレジットカード情報を入力してください。"
      return render :new
    end

    ActiveRecord::Base.transaction do
      @reservation.save!
      charge = ApiPayjp.charge(@reservation.total_price, params['payjp-token'])
      @reservation.update_attributes!(charge_id: charge.id)
      redirect_to space_path(@reservation.space), notice: "予約が完了しました"
    end
  end

  def destroy
    reservation = current_user.reservations.find(params[:id])

    ActiveRecord::Base.transaction do
      reservation.destroy!
      charge = ApiPayjp.get_charge(reservation.charge_id)
      ApiPayjp.refund(charge)
      redirect_to users_reservations_path, notice: "予約の削除が完了しました。"
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:space_id, :start_time, :end_time)
  end

  def set_reservation
    @reservation = current_user.reservations.build(reservation_params)
  end

  def render_spaces_show
    @space = Space.find(params[:reservation][:space_id])
    @reviews = @space.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
    @review = Review.new
    render 'spaces/show'
  end
end
