class Users::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @spaces = current_user.favorite_spaces.order("favorites.created_at DESC").page(params[:page]).without_count.per(MAX_DISPLAY_SPACE_COUNT)
  end

  def create
    @space = Space.find(params[:space_id])
    current_user.favorites.create!(space_id: @space.id)
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id]).destroy!
  end
end
