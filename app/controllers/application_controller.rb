class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def admin_only
    redirect_to restrooms_path, flash: {message: "You must log in as an admin to access this page."} unless current_user.admin?
  end

  def require_login
    redirect_to restrooms_path, flash: {message: "Please log in first ;)"} if !logged_in?    
  end

  def flash_error(object)
    object.errors.full_messages.join(", ")
  end

  helper_method [:current_user, :logged_in?]
end
