class StaticPagesController < ApplicationController
  def home
    @spaces = Space.all.page(params[:page]).per(10)
    @search_params = {}
  end

  def search
    @search_params = search_params
    @result_spaces = Space.users_search(@search_params).page(params[:page]).per(10)
  end

  private

  def search_params
    params.fetch(:search, {}).permit(:prefecture_code, :address_keyword, :start_datetime, :times, :hourly_price)
  end
end
