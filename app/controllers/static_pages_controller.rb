class StaticPagesController < ApplicationController
  def home
    @rooms = Room.all
  end
end
