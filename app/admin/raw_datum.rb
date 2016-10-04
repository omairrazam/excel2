ActiveAdmin.register RawDatum do

	filter :sensor_id
	filter :sensor_type

	index do
	    selectable_column
	    column :id
	    column :date
	    column :time
	    column :sensor_id
	    column :sensor_type
	    column :sensor_value
	    column :millis

	    
	    actions
	end
end