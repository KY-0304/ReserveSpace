class StaticPagesController < ApplicationController
  before_action :set_search_params

  def home
    @spaces = Space.all.page(params[:page]).per(10)
  end

  def search
    @result_spaces = Space.users_search(@search_params).page(params[:page]).per(10)
  end

  private

  def set_search_params
    @search_params = search_params
  end

  def search_params
    params.fetch(:search, {}).permit(:prefecture_code, :address_keyword, :start_datetime, :times, :hourly_price)
  end
end
