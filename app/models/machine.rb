class Machine < ActiveRecord::Base
	#scope :average_by_day, -> date{ where(Date: date) if date.present?}
	belongs_to :user
	has_many   :datums
	has_many   :offtimes

	def update_offtimes
		#debugger
		offtime_last_date 	= self.offtimes.last.try(:date) 
		datum_first_date    = self.datums.first.Date
		starting_date  		= offtime_last_date

		if offtime_last_date.blank?
			starting_date   = datum_first_date
		end

		hash 		 = self.datums.all.where('Date>=?', starting_date).group_by{ |dat| dat.Date.to_date }
		last_visited = 0
		hash.each{|date,dats|
			# condition to check if this date is less than last_visited
			# then next
			# date_offtime variable = 0 
			date_offtime 		       = 0
			date_maximum_cont_on_time  = 0
			date_maximum_cont_off_time = -1

			current_date_datums = self.datums.all.where("Date=?",date)
			last_compared_id    = -1
			current_date_datums.each_with_index {|dat,index|
				# if machine is off?
					# ask it to caculate its off time and return last datum timestamp and time
					# add to date_offtime variable
				time_difference = 0
				
				if dat.id < last_compared_id
					next
				end
				
				if dat.state == "off"	
					next_on_datum   = current_date_datums.where("state =? and id >?" , "on" , dat.id).limit(1)
					
					if next_on_datum.count > 0
						time_difference  	= next_on_datum.first.Time.minus_with_coercion(dat.Time)/60
						last_compared_id 	= next_on_datum.first.id

						
						if time_difference < date_maximum_cont_off_time || date_maximum_cont_off_time == -1
							date_maximum_cont_off_time = time_difference
						end

						date_offtime = date_offtime + time_difference
					end
				elsif dat.state == "on"
					next_on_datum   = current_date_datums.where("state =? and id >?" , "off" , dat.id).limit(1)
					
					if next_on_datum.count > 0
						time_difference  	= next_on_datum.first.Time.minus_with_coercion(dat.Time)/60
						last_compared_id 	= next_on_datum.first.id

						if time_difference > date_maximum_cont_on_time || date_maximum_cont_on_time == -1
							date_maximum_cont_on_time = time_difference
						end
					end
				end
			}
			# save this date | offtime in its offtime table
			#debugger
			offtime 					  = self.offtimes.where(date: date).first_or_initialize
			offtime.minutes 			  = date_offtime
			offtime.maximum_cont_off_time = date_maximum_cont_off_time
			offtime.maximum_cont_on_time  = date_maximum_cont_on_time
			#offtime = self.offtimes.build(:date => date, :minutes => date_offtime)
			offtime.save!

		}
	end

	def all_dates
		self.datums.uniq.pluck(:Date)
	end

	def get_offdatums
		self.datums.find_by(:state => "off")
	end

	def average_value_by_day(date)
		 datums.where('Date=?', date).average(:Number).to_f.round(2)
	end

	def maximum_value_by_day(date)
		 datums.where('Date=?', date).maximum(:Number).to_f.round(2)
	end

	def minimum_value_by_day(date)
		 datums.where('Date=?', date).minimum(:Number).to_f.round(2)
	end
end
