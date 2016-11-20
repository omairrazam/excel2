class RawDatum < ActiveRecord::Base
	self.table_name = "thedata"
	scope :machine_data, -> (last_id,type,machine_id){where("id >? and sensor_type=? and sensor_id=?", last_id,type,machine_id)}

	def self.load_from_file
		self.delete_all
		data     = CSV.read(Rails.root.to_s +  "/datafile/data.csv")
	   	dats     = []
	   	header   = data[0]

	    #columns = [:open, :close, :low,:high]
	    (1..data.count).each do |i| 
	        if data[i].blank?
	    		next
	    	end

	        row = Hash[[header, data[i]].transpose]
	       
	        d = RawDatum.new 
			
			d.date   	    = row["date"]
			d.time   	    = row["time"]
			d.sensor_id     = row["sensor_id"]
			d.sensor_value  = row["sensor_value"]
			d.sensor_type	= row["sensor_type"]
			d.millis   		= row["millis"]
			d.id 			= row["id"]

			dats << d
		end

	    columns_without_id = RawDatum.column_names.reject { |column| column == 'id' }
	    RawDatum.import(columns_without_id,dats)
	 
	end
end
