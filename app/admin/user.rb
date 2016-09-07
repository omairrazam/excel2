ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
# 
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  filter :email

  permit_params :email,:username, :password, :is_admin, :sheet_name,:send_reports

  index do
    selectable_column
    column :email
    column :username
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :send_reports
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :username
      f.input :password
      f.input :is_admin
      f.input :send_reports
    end
    f.actions
  end  

  show do
    attributes_table :email, :is_admin, :sheet_name,:send_reports
  end
  controller do
    
  end

  sidebar "Machine Details", only: [:show, :edit] do
    ul do
      li link_to "Machines",    admin_user_machines_path(user)
    end
  end
  
end
