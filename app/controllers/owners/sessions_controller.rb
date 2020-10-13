# frozen_string_literal: true

class Owners::SessionsController < Devise::SessionsController
  before_action :exclude_user,             only: [:new, :create]
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

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [])
  end

  def exclude_user
    redirect_to root_path, alert: "利用者側でログアウトしてから掲載者ログインをしてください。" if user_signed_in?
  end
end
