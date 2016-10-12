class BaseMachineProcessor

	protected
	def add_timestamp_to_datum
		timestamp    = @raw_datum.date.to_s + ' ' + @raw_datum.time.strftime('%H:%M:%S').to_s
		timestamp    = timestamp.to_datetime.beginning_of_minute.strftime('%s').to_i * 1000
		@datum.timestampe = timestamp
	end

	def set_state_of_datum
		if @raw_datum.sensor_value < @machine_instance.threshold
			@datum.state = "off"
		else
			@datum.state = "on"
		end
	end

	def add_min_max(last_datum)
		time_difference = @datum.timestampe - last_datum.timestampe if last_datum.present?
		if last_datum.blank? or (@datum.state != last_datum.state) or (@datum.datee != last_datum.datee) or (time_difference > 3*60000) # time difference is in milliseconds.
			@datum.cont_on_time  = 0
			@datum.cont_off_time = 0
		else
			if @datum.state == 'off'
				@datum.cont_on_time   = 0
				#debugger
				@datum.cont_off_time = last_datum.cont_off_time + time_difference
			else
				@datum.cont_off_time   = 0
				@datum.cont_on_time    = last_datum.cont_on_time + time_difference
			end
		end
	end
end