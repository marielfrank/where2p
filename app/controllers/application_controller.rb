class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  # check if user is logged in
  def logged_in?
    !!current_user
  end

  # determine current user
  def current_user
    User.find_by(id: session[:user_id])
  end

  # redirect if not admin
  def require_admin
    redirect_to restrooms_path, flash: {message: "Please log in as an admin to access that page."} unless logged_in? && current_user.admin?
  end

  # redirect if not logged in
  def require_login
    redirect_to restrooms_path, flash: {message: "Please log in first ;)"} if !logged_in?    
  end

  # get error message
  def flash_error(object)
    object.errors.full_messages.join(", ")
  end

  def log_user_in
    session[:user_id] = @user.id
    redirect_to restrooms_path, flash: {message: "Welcome, #{@user.name}!"}
  end

  # allow current_user and logged_in? to be used in views
  helper_method [:current_user, :logged_in?]
end
