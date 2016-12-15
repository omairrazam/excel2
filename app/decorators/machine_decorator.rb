class MachineDecorator
	attr_reader :machine, :default_date, :default_hour

	def initialize(machine, date=nil, hour=nil)
		@machine = machine

		if date.blank?
			date = last_datum_date
		end

		@default_hour = hour
		@default_date = date
	end

	def cont_on_time
		dats  = @machine.datums.find_by_date(@default_date)
		time  = dats.present? ? dats.maximum(:cont_on_time) : 0
		
		if @default_hour.present? 
			time = 0
			if dats.present?
				dats = dats.by_hour(@default_hour)
				max_dat = dats.where('cont_on_time =?', dats.maximum(:cont_on_time)).first

				lower_cont_on_time = 0
				upper_cont_on_time = 0

				dats_lower = dats.where('id<=?',max_dat.id)
				lower_cont_on_time = dats_lower.maximum(:cont_on_time) - dats_lower.minimum(:cont_on_time) if dats_lower.present?
				
				dats_upper = dats.where('id>?',max_dat.id)
				upper_cont_on_time = dats_upper.maximum(:cont_on_time) - dats_upper.minimum(:cont_on_time) if dats_upper.present?
				
				time = (lower_cont_on_time > upper_cont_on_time) ? lower_cont_on_time : upper_cont_on_time
			end
		end

		seconds  = time /1000 #seconds
		mins     = seconds / 60
		hrs      = mins / 60
		final    = hrs.to_s + "h " + (mins%60).to_s + "m"
	end

	def cont_off_time
		dats = @machine.datums.find_by_date(@default_date)
		time = dats.present? ? dats.maximum(:cont_off_time) : 0

		if @default_hour.present?  
			dats = dats.by_hour(@default_hour) 

			max_dat = dats.where('cont_off_time =?', dats.maximum(:cont_off_time)).first

			lower_cont_off_time = 0
			upper_cont_off_time = 0

			dats_lower = dats.where('id<=?',max_dat.id)
			lower_cont_off_time = dats_lower.maximum(:cont_off_time) - dats_lower.minimum(:cont_off_time) if dats_lower.present?
			
			dats_upper = dats.where('id>?',max_dat.id)
			upper_cont_off_time = dats_upper.maximum(:cont_off_time) - dats_upper.minimum(:cont_off_time) if dats_upper.present?
			
			time = (lower_cont_off_time > upper_cont_off_time) ? lower_cont_off_time : upper_cont_off_time
		end
		
		seconds  = time /1000 #seconds
		mins     = seconds / 60
		hrs      = mins / 60

		final = hrs.to_s + "h " + (mins%60).to_s + "m"
	end

	def average_value_by_day
		return 0 if !has_data?
		
		dats = @machine.datums.find_by_date(@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		dats.average(:numbere).to_f.round(2) 
	end

	def maximum_value_by_day
		return 0 if !has_data?

		dats = @machine.datums.find_by_date(@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		dats.maximum(:numbere).to_f.round(2) 
	end

	def total_monitored_time
		return 0 if !has_data?
		
		dats = @machine.datums.find_by_date(@default_date)
		
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		d = dats.count  
		d = d*60/60

		hrs   = d / 60
		mins  = d % 60

		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def total_datums
		#return 0 if !has_data?
		
		dats = @machine.datums.find_by_date(@default_date)
		
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		dats.count 
	end

	def total_uptime
		return 0 if !has_data?

		dats = @machine.datums.where('state=? AND datee=?','on',@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		d     = dats.count
		d     = d*60/60
		hrs   = d / 60
		mins  = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end







	def create_hourly_stat
		HourlyStat.create(machine_id: @machine.acting_as.id, 
						  datee: @default_date, 
						  hour: @default_hour, 
						  total_monitored_time: self.total_monitored_time,
						  total_datums: self.total_datums,
						  total_uptime: self.total_uptime,
						  # cont_ontime:  self.cont_on_time,
						  # cont_offtime: self.cont_off_time,
						  # efficiency:   self.efficiency
						  )
	end



	def last_datum_date
		date = @machine.datums.order('datee asc').last.datee.strftime("%Y-%m-%d") rescue '-' 
	end

	def live_value
		@machine.datums.last.numbere rescue '-' if has_data?
	end

	def grapher_data
		@machine.getdata_for_graph(@default_date) if has_data?
	end

	def grapher_offtime_data
		self.offtimes.order("timestampe asc").pluck(:timestampe, :efficiency)	
		#@machine.getofftimes_for_graph if has_data?
	end

	def has_data?
		@machine.datums.where('datee=?',@default_date).present?
	end
	
	def method_missing(method_name,*args,&block)
		@machine.send(method_name, *args,&block)
	end

	def respond_to_missing?(method_name,include_private = false)
		@machine.respond_to?(method_name, include_private) || super
	end
end