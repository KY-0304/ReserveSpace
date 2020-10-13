class Users::GuestsController < ApplicationController
  def create
    sign_in User.guest
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。"
  end
end
