module ApplicationHelper
def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def nav_class(link_path)
	  class_name = current_page?(link_path)  ? 'active' : ''
	  #class_name = current_page?(extra_path) ? 'active' : ''
	  
	end

end
