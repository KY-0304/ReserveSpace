class Users::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.favorite_rooms
  end

  def create
    @room = Room.find(params[:room_id])
    current_user.favorites.create!(room_id: @room.id)
    respond_to do |format|
      format.html { redirect_to room_path(@room) }
      format.js
    end
  end

  def destroy
    @room = Room.find(params[:id])
    current_user.favorites.find_by(room_id: @room.id).destroy!
    respond_to do |format|
      format.html { redirect_to room_path(@room) }
      format.js
    end
  end
end
