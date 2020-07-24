class RoomsController < ApplicationController
  before_action :authenticate_owner!, except: :show

  def index
    @rooms = current_owner.rooms.page(params[:page]).per(10)
  end

  def show
    @room = Room.includes(reviews: :user).find(params[:id])
    @reservation = Reservation.new
    @review = Review.new
  end

  def new
    @room = current_owner.rooms.build
  end

  def create
    @room = current_owner.rooms.build(room_params)
    if @room.save
      flash[:success] = "会議室の登録を完了しました"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def edit
    @room = current_owner.rooms.find(params[:id])
  end

  def update
    @room = current_owner.rooms.find(params[:id])
    if @room.update_attributes(room_params)
      flash[:success] = "会議室の編集が完了しました"
      redirect_to rooms_path
    else
      render :edit
    end
  end

  def destroy
    current_owner.rooms.find(params[:id]).destroy!
    flash[:success] = "会議室の削除が完了しました"
    redirect_to rooms_path
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :image, :image_cache, :remove_image, :postcode,
                                 :prefecture_code, :address_city, :address_street, :address_building,
                                 :phone_number, :hourly_price, :business_start_time, :business_end_time)
  end
end
