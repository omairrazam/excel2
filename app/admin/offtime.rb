ActiveAdmin.register Offtime do
config.clear_action_items!
	
	index do
	    selectable_column
	    column :id
	    column :date
	    column :minutes
	    column :maximum_cont_on_time
	    column :maximum_cont_off_time
	    column :timestampe
	    column :efficiency

	    
	    #actions
	end

end
