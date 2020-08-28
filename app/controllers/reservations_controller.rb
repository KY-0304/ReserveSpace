class ReservationsController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_space_and_search_params

  def index
    @reservations = @space.reservations.includes(:user).order(start_time: :desc).page(params[:page]).per(50)
  end

  def search
    @reservations = @space.reservations.includes(:user).owners_search(@search_params).order(start_time: :desc).page(params[:page]).per(50)
    render :index
  end

  private

  def set_space_and_search_params
    @space = current_owner.spaces.find(params[:space_id])
    @search_params = search_params
  end

  def search_params
    params.fetch(:search, {}).permit(:start_datetime, :end_datetime)
  end
end
