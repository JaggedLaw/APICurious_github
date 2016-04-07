class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :current_user, :api_service

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def api_service(current_user)
    @api_service ||= ApiService.new(current_user) if current_user
  end

end
