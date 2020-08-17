class SettingsController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_space_and_setting

  def edit
  end

  def update
    if @setting.update_attributes(setting_params)
      redirect_to space_path(@space), notice: "設定を保存しました。"
    else
      render :edit
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:date_range_reservation_unacceptable,
                                    :reservation_unacceptable_start_day,
                                    :reservation_unacceptable_end_day)
  end

  def set_space_and_setting
    @space = current_owner.spaces.find(params[:space_id])
    @setting = @space.setting
  end
end
