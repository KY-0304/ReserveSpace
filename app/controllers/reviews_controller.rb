class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_to room_path(params[:room_id])
    else
      @room = Room.includes(reviews: :user).find(params[:room_id])
      @reservation = Reservation.new
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
    params.require(:review).permit(:rate, :comment).merge(room_id: params[:room_id])
  end
end
