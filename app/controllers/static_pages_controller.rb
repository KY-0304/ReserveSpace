class StaticPagesController < ApplicationController
  before_action :set_search_params

  def home
    @spaces = Space.all.order(impressions_count: :desc).page(params[:page]).without_count.per(MAX_DISPLAY_SPACE_COUNT)
  end

  def search
    @result_spaces = Space.users_search(@search_params).order(impressions_count: :desc).
      page(params[:page]).without_count.per(MAX_DISPLAY_SPACE_COUNT)
  end

  def about
  end

  private

  def set_search_params
    @search_params = search_params
  end

  def search_params
    params.fetch(:search, {}).permit(:prefecture_code, :address_keyword, :start_datetime, :times, :hourly_price, :capacity)
  end
end
