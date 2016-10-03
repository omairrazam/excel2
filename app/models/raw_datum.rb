class RawDatum < ActiveRecord::Base
	self.table_name = "thedata"
	scope :machine_data, -> (last_id,type,machine_id){where("id >? and sensor_type=? and sensor_id=?", last_id,type,machine_id)}
end
