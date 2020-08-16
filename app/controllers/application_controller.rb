class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :error500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404 unless Rails.env.development?

  def error404(e)
    render "error404", status: :not_found, formats: :html
  end

  def error500(e)
    logger.error [e, *e.backtrace].join("\n")
    render "error500", status: :internal_server_error, formats: :html
  end

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Owner)
      spaces_path
    else
      root_path
    end
  end
end
