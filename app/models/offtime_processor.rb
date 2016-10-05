class OfftimeProcessor
	attr_accessor :machine_instance, :last_date, :first_date, :starting_date

	def initialize(machine)
		@machine_instance = machine

		@last_date 	    = @machine_instance.offtimes.last.try(:date) 
		
		@first_date     = @machine_instance.datums.first.datee
		@starting_date  = @last_date

		if @last_date.blank?
			@starting_date = @first_date
		end

	end

	def find_offtimes

		hash 		 = @machine_instance.datums.all.where('datee>=?', starting_date).order('timestampe asc').group_by{ |dat| dat.datee.to_date }
	
		hash.each{|date,dats|
			date_offtime 		       =  0
			date_maximum_cont_on_time  =  0
			date_maximum_cont_off_time =  0

			offtime_instance = DateOfftime.new(@machine_instance, date)
			offtime_instance.find_offtime
			
			offtime 		 = @machine_instance.offtimes.where(date: date).first_or_initialize
			offtime.minutes  = offtime_instance.total_offtime

			offtime.maximum_cont_off_time = offtime_instance.max_cont_off_ontime
		
			offtime.maximum_cont_on_time  = offtime_instance.max_cont_on_ontime
		    
			offtime.efficiency			  = @machine_instance.efficiency(date)
			offtime.timestampe            = date.strftime('%s').to_i * 1000
			offtime.save!
			
		}
	end

	

end