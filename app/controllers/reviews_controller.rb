class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    @room.reviews.build(review_params)
    if @room.save
      flash[:success] = "レビューを投稿しました"
      redirect_to room_path(@room)
    else
      render 'rooms/show'
    end
  end

  def destroy
    review = current_user.reviews.find(params[:id]).destroy!
    flash[:success] = "レビューを削除しました"
    redirect_to room_path(review.room)
  end

  private

  def review_params
    params.require(:review).permit(:rate, :comment).merge(user_id: current_user.id)
  end
end
