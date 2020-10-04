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

  # 検索内容保持の目的で、viewに@search_paramsを使用しているのでrequireではなく、fetchを使用してエラーを回避
  def search_params
    params.fetch(:search, {}).permit(:prefecture_code, :address_keyword, :start_datetime, :times, :hourly_price, :capacity)
  end
end
