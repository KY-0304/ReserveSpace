class ApplicationController < ActionController::Base
  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Owner)
      rooms_path
    else
      root_path
    end
  end
end
