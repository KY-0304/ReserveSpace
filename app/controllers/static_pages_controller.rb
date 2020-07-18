class StaticPagesController < ApplicationController
  def home
    @rooms = Room.all.page(params[:page]).per(6)
  end
end
