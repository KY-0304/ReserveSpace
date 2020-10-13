# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :exclude_owner,            only: [:new, :create]
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

  def exclude_owner
    redirect_to root_path, alert: "掲載者側でログアウトしてから利用者ログインをしてください。" if owner_signed_in?
  end
end
