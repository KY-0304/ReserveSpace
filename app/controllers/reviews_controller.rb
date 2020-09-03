class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    respond_to do |format|
      if @review.save
        @review = current_user.reviews.build
        @space = Space.find(params[:space_id])
        @reviews = @space.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
        format.js
      else
        @space = Space.find(params[:space_id])
        @reviews = @space.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
        format.js
      end
    end
  end

  def destroy
    @review = current_user.reviews.find(params[:id]).destroy!
    respond_to { |format| format.js }
  end

  private

  def review_params
    params.require(:review).permit(:rate, :comment).merge(space_id: params[:space_id])
  end
end
