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
    
    if current_user.sign_in_count == 1
      m1 = resource.machines.build
      m1.name = "SHEL001"
      m1.save

      m2 = resource.machines.build
      m2.name = "SHEL002"
      m2.save

      m3 = resource.machines.build
      m3.name = "SHEL003"
      m3.save

      m4 = resource.machines.build
      m4.name = "SHEL004"
      m4.save

      m5 = resource.machines.build
      m5.name = "SHEL005"
      m5.save
    end

    if resource.is_admin?
        admin_dashboard_path
    else
        root_path
    end
  end
end
