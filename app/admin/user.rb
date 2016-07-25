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

  permit_params :email, :password, :is_admin, :sheet_name
  index do
    selectable_column
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :sheet_name
    actions
  end



  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :is_admin
      f.input :sheet_name
    end
    f.actions
  end  

  show do
    attributes_table :email, :is_admin, :sheet_name
  end
  controller do
    
  end
  
end
