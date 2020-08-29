class ReservationsController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_space_and_search_params_and_reservations

  def index
  end

  def search
    respond_to do |format|
      format.html { render :index }
      format.csv { send_data render_to_string, filename: "#{@space.name}予約一覧.csv", type: :csv }
    end
  end

  private

  def set_space_and_search_params_and_reservations
    @space = current_owner.spaces.find(params[:space_id])
    @search_params = search_params
    @reservations = @space.reservations.includes(:user).owners_search(@search_params).order(start_time: :desc).page(params[:page]).per(50)
  end

  def search_params
    params.fetch(:search, {}).permit(:start_datetime, :end_datetime)
  end
end
