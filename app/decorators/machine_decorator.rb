class MachineDecorator
	attr_reader :machine

	def initialize(machine)
		@machine = machine
	end

	def average_value_by_day(date)
		 @machine.datums.find_by_date(date).average(:numbere).to_f.round(2)
	end

	def maximum_value_by_day(date)
		 @machine.datums.find_by_date(date).maximum(:numbere).to_f.round(2)
	end

	def minimum_value_by_day(date)
		 @machine.datums.find_by_date(date).minimum(:numbere).to_f.round(2)
	end

	def total_uptime(date)
		d = @machine.datums.where('numbere>=? AND datee=?',5,date).count
		d = d*68/60
		hrs  = d / 60
		mins = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
		#debugger
	end

	def has_data
		if self.datums.count <= 0
			return false
		else
			return true
		end
	end
	
	def total_monitored_time(date)
		#debugger
		d = @machine.datums.where('datee=?',date).count
		d = d*68/60
		hrs  = d / 60
		mins = d % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def method_missing(method_name,*args,&block)
		@machine.send(method_name, *args,&block)
	end

	def respond_to_missing?(method_name,include_private = false)
		@machine.respond_to?(method_name, include_private) || super
	end
end