class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_to room_path(@room)
    else
      @reservations = @room.reservations
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
    params.require(:review).permit(:rate, :comment, :room_id).merge(user_id: current_user.id, room_id: params[:room_id])
  end
end
