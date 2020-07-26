class SpacesController < ApplicationController
  before_action :authenticate_owner!, except: :show

  def index
    @spaces = current_owner.spaces.page(params[:page]).per(10)
  end

  def show
    @space = Space.includes(reviews: :user).find(params[:id])
    @reservation = Reservation.new
    @review = Review.new
  end

  def new
    @space = current_owner.spaces.build
  end

  def create
    @space = current_owner.spaces.build(space_params)
    if @space.save
      flash[:success] = "スペースの登録を完了しました"
      redirect_to spaces_path
    else
      render :new
    end
  end

  def edit
    @space = current_owner.spaces.find(params[:id])
  end

  def update
    @space = current_owner.spaces.find(params[:id])
    if @space.update_attributes(space_params)
      flash[:success] = "スペースの編集が完了しました"
      redirect_to spaces_path
    else
      render :edit
    end
  end

  def destroy
    current_owner.spaces.find(params[:id]).destroy!
    flash[:success] = "スペースの削除が完了しました"
    redirect_to spaces_path
  end

  private

  def space_params
    params.require(:space).permit(:name, :description, :image, :image_cache, :remove_image, :postcode,
                                  :prefecture_code, :address_city, :address_street, :address_building,
                                  :phone_number, :hourly_price, :business_start_time, :business_end_time)
  end
end
