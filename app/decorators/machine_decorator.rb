class MachineDecorator
	attr_reader :machine, :default_date

	def initialize(machine, date=nil)
		@machine = machine

		if date.blank?
			date = last_datum_date
		end
		
		@default_date = date
	end

	

	def cont_on_time
		#debugger
		time = self.datums.where('datee=?', @default_date).maximum(:cont_on_time) || 0
		time = time/1000 #seconds
		hrs   = time / 3600
		mins  = time % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def cont_off_time
	
		time  = self.datums.where('datee=?', @default_date).maximum(:cont_off_time)|| 0
		time  = time/1000 #seconds
		hrs   = time / 3600
		mins  = time % 60

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
		@machine.getofftimes_for_graph if has_data?
	end

	def average_value_by_day
		 @machine.datums.find_by_date(@default_date).average(:numbere).to_f.round(2) if has_data?
	end

	def maximum_value_by_day
		 @machine.datums.find_by_date(@default_date).maximum(:numbere).to_f.round(2) if has_data?
	end

	def minimum_value_by_day
		 @machine.datums.find_by_date(@default_date).minimum(:numbere).to_f.round(2) if has_data?
	end

	def total_uptime
		#debugger
		d     = @machine.datums.where('state=? AND datee=?','on',@default_date).count
		d     = d*60/60
		hrs   = d / 60
		mins  = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def has_data?
		@machine.datums.where('datee=?',@default_date).present?
	end
	
	def total_monitored_time
		#debugger
		d = @machine.datums.where('datee=?',@default_date).count  #737
		d = d*60/60

		hrs   = d / 60
		mins  = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def method_missing(method_name,*args,&block)
		@machine.send(method_name, *args,&block)
	end

	def respond_to_missing?(method_name,include_private = false)
		@machine.respond_to?(method_name, include_private) || super
	end
end