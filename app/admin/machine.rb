ActiveAdmin.register Machine do
 belongs_to :user
 permit_params :name, :sheetname, :threshold, :data_type, :next_index_excel, :user_id, :unique_id
 config.filters = false


index do
    selectable_column
    column :name
    column :threshold
    column :actable_type
    column :unique_id
    column :next_index_excel
    actions
end

form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :threshold
      f.input :unique_id
      if params[:action] == 'edit'
      f.input :data_type,  as: :select, collection: ["Current","Temperature","Counter","Rpm"], :input_html => { :disabled => true } 
      else
      f.input :data_type,  as: :select, collection: ["Current","Temperature","Counter","Rpm"]
  	  end
    end
    f.actions
end  

controller do
    def create
      machine_type     = permitted_params[:machine]["data_type"]+"Machine" 	
      machine_instance = machine_type.constantize.new(permitted_params[:machine])
      machine_instance.next_index_excel = 1

      if machine_instance.save
      	user = User.find(params["user_id"])
      	user.machines << machine_instance
    	  machine_instance.process
    	  redirect_to admin_user_machines_path, notice: "#{machine_type} created successfully"
      else
      	render :edit
  	  end
    end
end
  

end
