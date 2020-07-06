class RoomsController < ApplicationController
  before_action :authenticate_owner!, except: :show

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = current_owner.rooms.build
  end

  def create
    @room = current_owner.rooms.build(room_params)
    if @room.save
      flash[:notice] = "会議室の登録を完了しました"
      redirect_to owners_path
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
      flash[:notice] = "会議室の編集が完了しました"
      redirect_to owners_path
    else
      render :edit
    end
  end

  def destroy
    @room = current_owner.rooms.find(params[:id])
    @room.destroy
    flash[:notice] = "会議室の削除が完了しました"
    redirect_to owners_path
  end

  private

  def room_params
    params.require(:room).
      permit(:name, :description, :image, :address, :phone_number, :hourly_price, :business_start_time, :business_end_time)
  end
end
