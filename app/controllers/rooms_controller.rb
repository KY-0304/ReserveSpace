class RoomsController < ApplicationController
  before_action :authenticate_owner!, except: :show
  before_action :correct_owner, only: [:edit, :update, :destroy]

  def index
    @rooms = current_owner.rooms
  end

  def show
    @room = Room.find(params[:id])
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
  end

  def update
    if @room.update_attributes(room_params)
      flash[:success] = "会議室の編集が完了しました"
      redirect_to rooms_path
    else
      render :edit
    end
  end

  def destroy
    @room.destroy!
    flash[:success] = "会議室の削除が完了しました"
    redirect_to rooms_path
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :image, :postcode, :prefecture_code, :address_city,
                                 :address_street, :address_building, :phone_number, :hourly_price,
                                 :business_start_time, :business_end_time)
  end

  def correct_owner
    @room = current_owner.rooms.find_by(id: params[:id])
    unless @room
      flash[:warning] = "会議室が見つかりませんでした"
      redirect_to rooms_path
    end
  end
end
