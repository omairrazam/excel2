class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  
  # def authenticate_admin!
  #  #redirect_to new_user_session_path #unless current_user.is_admin?
  #  #redirect_to admin_root_path
  # end

  def authenticate_admin_user!
    raise SecurityError unless current_user.is_admin 
  end

  rescue_from SecurityError do |exception|
    redirect_to root_path , flash: {notice: "Access Denied"}
  end
  
  def after_sign_in_path_for(resource)
    root_path
  end
end
