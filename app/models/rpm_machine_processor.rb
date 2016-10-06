class RpmMachineProcessor < BaseMachineProcessor

	def initialize(machine_instance)
		@machine_instance = machine_instance
		@raw_datum = nil
		@datum     = nil
		@previous_datum = nil
	end

	def process_raw_datum(raw_datum)
		
		@raw_datum = raw_datum
		@datum 	   = Datum.new
		@datum.timee 	  = @raw_datum.time
		@datum.datee 	  = @raw_datum.date
		@datum.numbere 	  = @raw_datum.sensor_value 
		@datum.machine_id = @machine_instance.acting_as.id

        add_timestamp_to_datum
        set_state_of_datum

        fill_gradient
        @datum
	end

	private

	def fill_gradient
		if @previous_datum.present?
			dy = (@raw_datum.sensor_value - @previous_datum.sensor_value) * 60000
			dx = @raw_datum.millis   - @previous_datum.millis

			if dx > 0
			 	@datum.gradient  = (dy.to_f/dx.to_f).round(2)
			else
			 	@previous_datum.sensor_value = 0
			 	@previous_datum.millis		 = 0
			 	#skip this row
			 	@datum = nil
			end
		else
			@datum.gradient = 0
			@previous_datum = @datum
		end
	end

end