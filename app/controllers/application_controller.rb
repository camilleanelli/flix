class ApplicationController < ActionController::Base
  add_flash_types(:danger)

  helper_method :current_user
  helper_method :current_user?
  helper_method :current_user_admin?
  private

  def require_signin
    unless current_user
      session[:toto] = request.url
      redirect_to signin_path
    end
  end

  def require_admin
    unless current_user_admin?
      redirect_to root_path
    end
  end

  def current_user_admin?
    current_user&.admin
  end
  
  def current_user?(user)
    user == current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


end
