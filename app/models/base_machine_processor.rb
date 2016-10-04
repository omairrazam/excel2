class BaseMachineProcessor

	protected
	def add_timestamp_to_datum
		timestamp    = @raw_datum.date.to_s + ' ' + @raw_datum.time.strftime('%H:%M:%S').to_s
		timestamp    = timestamp.to_datetime.beginning_of_minute.strftime('%s').to_i * 1000
		@datum.timestampe = timestamp
	end

	def set_state_of_datum
		if @raw_datum.sensor_value < @counter_machine_instance.threshold
			@datum.state = "off"
		else
			@datum.state = "on"
		end
	end
end