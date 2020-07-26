class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_to space_path(params[:space_id])
    else
      @space = Space.includes(reviews: :user).find(params[:space_id])
      @reservation = Reservation.new
      render 'spaces/show'
    end
  end

  def destroy
    review = current_user.reviews.find(params[:id]).destroy!
    flash[:success] = "レビューを削除しました"
    redirect_to space_path(review.space)
  end

  private

  def review_params
    params.require(:review).permit(:rate, :comment).merge(space_id: params[:space_id])
  end
end
