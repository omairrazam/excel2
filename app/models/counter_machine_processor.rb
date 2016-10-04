class CounterMachineProcessor < BaseMachineProcessor
	attr_accessor :raw_datum, :last_value, :pivot_value, :offset_value, :counter_machine_instance, :datum

	def initialize(machine_instance)
		@pivot_value  = 0
		@offset_value = 0
		@last_value   = 0 
		@counter_machine_instance = machine_instance
		
	end

	def process_raw_datum(raw_dat)
       @raw_datum = raw_dat
       @datum 	  = Datum.new
        # check for zero value
       	if @raw_datum.sensor_value == 0
       		process_zero_value
       		return nil
       	end

       	# fill object
		@datum.timee 	  = @raw_datum.time
		@datum.datee 	  = @raw_datum.date
		@datum.numbere 	  = @raw_datum.sensor_value + @offset_value - @pivot_value
		@datum.machine_id = @counter_machine_instance.acting_as.id
		@datum.gradient   = @raw_datum.sensor_value.to_f - @last_value
        add_timestamp_to_datum
        set_state_of_datum

        # check if reset counter is required
       	reset_counter_check
       	@last_value = @raw_datum.sensor_value
       	# return object
        @datum

	end

	private


	def reset_counter_check
		if @datum.timee.strftime("%H:%M:%S") == "23:59:59" or  @datum.timee.strftime("%H:%M") == "12:00:00"
			reset_counter
		end
	end

	def reset_counter
		@offset_value  = 0
		@pivot_value   = @raw_datum.sensor_value 
		@datum.numbere = 0
	end

	def process_zero_value
		@offset_value += @last_value
		@last_value    = @raw_datum.sensor_value
	end

	
end