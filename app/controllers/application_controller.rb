class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    return if current_user

    redirect_to new_session_path, alert: "Faça login para continuar"
  end

  def redirect_if_authenticated
    redirect_to root_path if current_user
  end
end
