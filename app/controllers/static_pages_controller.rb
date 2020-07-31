class StaticPagesController < ApplicationController
  def home
    @spaces = Space.all.page(params[:page]).per(10)
  end
end
