class DateOfftime
	attr_accessor :machine_instance,:date, :last_compared_id, :all_datums, :total_offtime, :max_cont_off_ontime, :max_cont_on_ontime

	def initialize(machine,date)
		@machine_instance    = machine
		@last_compared_id    = -1
		@max_cont_on_ontime  = 0
		@max_cont_off_ontime = 0
		@total_offtime       = 0
		@date = date
	end

	def find_offtime
		@all_datums = @machine_instance.datums.all.where("datee=?",date).order('timestampe asc')
		@all_datums.each_with_index do |dat,index|
			process_each_datum(dat)
		end
	end

	private

	def process_each_datum(datum)
		
		if datum.id < @last_compared_id
			return
		end

		if datum.state == "off"
			find_state = "on"
		else
			find_state = "off"
		end
		
		next_on_datum = @all_datums.where("state =? and id >?" , find_state , datum.id).order('timestampe asc').limit(1)
		
		#make sure we have data in next_on_datum
		if next_on_datum.count == 0
			next_on_datum   = Array[@all_datums.last]
		end

		# all datums from current datum till next opposite state datum
		datum_chunk_range = @all_datums.where("id>? and id<=?", datum.id, next_on_datum.first.id)

		#initialize pivot to first value
		@date_pivot = datum.timestampe.to_i

		process_datum_chunk(datum_chunk_range)

		# for last datum or if there is no chunk diff of >= 3 in process_datum_chunk
		time_difference  	= (next_on_datum.first.timestampe.to_i - @date_pivot)/60000
		@last_compared_id 	= next_on_datum.first.id

		update_max_times(datum, time_difference)
		@total_offtime = @total_offtime + time_difference
	end

	def process_datum_chunk(datum_chunk_range)

		last_value = @date_pivot

		datum_chunk_range.each do |d_chunk|
			d_chunk_diff = (d_chunk.timestampe.to_i - last_value)/60000
			
			if d_chunk_diff >= 3
				d = last_value - @date_pivot
				d = d/60000 #in minutes
				# maximum continued off time check
				update_max_times(d_chunk,d)
				
				# date total offtime
				@total_offtime = @total_offtime + d
	            # change pivot
				@date_pivot = d_chunk.timestampe.to_i
				d = 0
			end

			last_value = d_chunk.timestampe.to_i
		end
	end

	def update_max_times(d_chunk, time_difference)
		if d_chunk.state == 'on'
			if time_difference > @max_cont_off_ontime 
				@max_cont_off_ontime  = time_difference
			end
		else
			if time_difference > @max_cont_on_ontime 
				@max_cont_on_ontime  = time_difference
			end
		end
	end
end