# frozen_string_literal: true

class Owners::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  def guest_sign_in
    owner = Owner.guest
    sign_in owner
    redirect_to spaces_path, notice: "ゲストオーナーとしてログインしました。"
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [])
  end
end
