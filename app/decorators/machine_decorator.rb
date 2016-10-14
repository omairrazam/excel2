class MachineDecorator
	attr_reader :machine, :default_date

	def initialize(machine, date=nil, hour=nil)
		@machine = machine

		if date.blank?
			date = last_datum_date
		end
		@default_hour = hour
		@default_date = date
	end

	def cont_on_time
		dats = self.datums.find_by_date(@default_date)

		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		time = dats.maximum(:cont_on_time) || 0
		time = time/1000 #seconds
		hrs   = time / 3600
		mins  = time % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def cont_off_time
		dats = self.datums.find_by_date(@default_date)

		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end
		
		time = dats.maximum(:cont_off_time) || 0
		time  = time /1000 #seconds
		hrs   = time / 3600
		mins  = time % 60

		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def average_value_by_day
		return 0 if !has_data?
		
		dats = self.datums.find_by_date(@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		dats.average(:numbere).to_f.round(2) 
	end

	def maximum_value_by_day
		return 0 if !has_data?

		dats = self.datums.find_by_date(@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		dats.maximum(:numbere).to_f.round(2) 
	end

	def total_monitored_time
		return 0 if !has_data?
		
		dats = self.datums.find_by_date(@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		d = dats.count  
		d = d*60/60

		hrs   = d / 60
		mins  = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def total_uptime
		return 0 if !has_data?

		dats = self.datums.where('state=? AND datee=?','on',@default_date)
		if @default_hour.present?
			dats = dats.by_hour(@default_hour)
		end

		d     = dats.count
		d     = d*60/60
		hrs   = d / 60
		mins  = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end











	def last_datum_date
		date = @machine.datums.order('datee asc').last.datee.strftime("%Y-%m-%d") rescue '-' 
	end

	def live_value
		@machine.datums.last.numbere rescue '-' if has_data?
	end

	def grapher_data
		@machine.getdata_for_graph if has_data?
	end

	def grapher_offtime_data
		self.offtimes.pluck(:timestampe, :efficiency)	
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