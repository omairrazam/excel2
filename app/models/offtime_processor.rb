class OfftimeProcessor
	def initialize(machine)
		@machine  = machine
		load_last_offtime
		update_last_offtime # new data might come for existing date
	end

	def process_new_datums
		# fetch all unique dates after last_date
		# for each date find its efficiency using machien's formula
		debugger
		dates = @machine.datums.find_after_date(@last_date).pluck(:datee).uniq
		all_offtimes = []
		
		dates.each do |d|
			e = @machine.efficiency(d)
			offtime 	          = Offtime.new
			offtime.efficiency 	  = e
			offtime.date 		  = d
			offtime.timestampe    = d.strftime("%s").to_i * 1000 # in milliseconds
			offtime.machine_id    = @machine.acting_as.id
			all_offtimes << offtime
		end

		Offtime.import all_offtimes  # bulk import to boost speed
	end

	private

	def load_last_offtime
		@last_offtime = @machine.offtimes.order("date asc").last # load existing value
		if @last_offtime.blank? # create a new one if not already existing
			@last_offtime            = Offtime.new
			@last_offtime.date       = @machine.datums.minimum(:datee)
			@last_offtime.machine_id = @machine.acting_as.id
			@last_offtime.timestampe = @last_offtime.date.strftime("%s").to_i * 1000 # in milliseconds
		end 
		@last_date = @last_offtime.try(:date) 
	end

	def update_last_offtime
		return if @last_date.blank?

		e = @machine.efficiency(@last_date)
		@last_offtime.efficiency = e
		@last_offtime.save
	end

end