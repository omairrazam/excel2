ActiveAdmin.register Machine do
 belongs_to :user
 permit_params :name, :sheetname, :threshold, :data_type, :next_index_excel
 config.filters = false
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

form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :threshold
      f.input :sheetname
      f.input :next_index_excel
      f.input :data_type,  as: :select, collection: ["Current","Temperature","Counter","Rpm"]

    end
    f.actions
end  

after_create do |m|
	m.fetch_data_from_excel
end

end
