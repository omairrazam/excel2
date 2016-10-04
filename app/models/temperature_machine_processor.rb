class TemperatureMachineProcessor < BaseMachineProcessor
	def initialize(machine_instance)
		@temperate_machine_instance = machine_instance
		@raw_datum = nil
		@datum     = nil
	end

	def process_raw_datum(raw_datum)
		@raw_datum = raw_datum
		@datum 	   = Datum.new

		@datum.timee 	  = @raw_datum.time
		@datum.datee 	  = @raw_datum.date
		@datum.numbere 	  = @raw_datum.sensor_value + @offset_value - @pivot_value
		@datum.machine_id = @counter_machine_instance.acting_as.id

        add_timestamp_to_datum
        set_state_of_datum

        @datum

	end

end