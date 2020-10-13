class Owners::GuestsController < ApplicationController
  def create
    sign_in Owner.guest
    redirect_to spaces_path, notice: "ゲストオーナーとしてログインしました。"
  end
end
