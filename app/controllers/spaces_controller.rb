class SpacesController < ApplicationController
  before_action :authenticate_owner!, except: :show
  before_action :set_space, only: [:edit, :update, :destroy]

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
  end

  def update
    if @space.update_attributes(space_params)
      flash[:success] = "スペースの編集が完了しました"
      redirect_to spaces_path
    else
      render :edit
    end
  end

  def destroy
    if @space.destroy
      redirect_to spaces_path, notice: "スペースの削除が完了しました"
    else
      render :edit
    end
  end

  private

  def space_params
    params.require(:space).permit(:name, :description, { images: [] }, :images_cache, :remove_images, :postcode,
                                  :prefecture_code, :address_city, :address_street, :address_building,
                                  :phone_number, :hourly_price, :business_start_time, :business_end_time)
  end

  def set_space
    @space = current_owner.spaces.find(params[:id])
  end
end
