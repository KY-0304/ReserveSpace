class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    @space = Space.find(params[:space_id])
    if @review.save
      @new_review = current_user.reviews.build
    else
      render :error
    end
  end

  def destroy
    @review = current_user.reviews.find(params[:id]).destroy!
  end

  private

  def review_params
    params.require(:review).permit(:rate, :comment).merge(space_id: params[:space_id])
  end
end
