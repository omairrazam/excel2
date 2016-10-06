class Machine < ActiveRecord::Base
	#scope :average_by_day, -> date{ where(Date: date) if date.present?}
	actable
	
	#relations
	belongs_to :user
	has_many   :datums   , dependent: :destroy
	has_many   :offtimes , dependent: :destroy

	#validations
	validates  :name     , presence: true
	validates  :threshold, presence: true
	validates  :data_type, presence: true
	validates  :next_index_excel, presence: true

	

	def update_offtimes
		if self.datums.count == 0
			return
		end
		offtime_last_date 	= self.offtimes.last.try(:date) 
		datum_first_date    = self.datums.first.datee
		starting_date  		= offtime_last_date

		if offtime_last_date.blank?
			starting_date   = datum_first_date
		end
		
		hash 		 = self.datums.all.where('datee>=?', starting_date).order('timestampe asc').group_by{ |dat| dat.datee.to_date }
		#debugger
		last_visited = 0
		hash.each{|date,dats|
			# condition to check if this date is less than last_visited
			# then next
			# date_offtime variable = 0 
			date_offtime 		       =  0
			date_maximum_cont_on_time  =  0
			date_maximum_cont_off_time =  0

			current_date_datums = self.datums.all.where("datee=?",date).order('timestampe asc')
			last_compared_id    = -1
			current_date_datums.each_with_index {|dat,index|
					
				
				#
				#debugger
				# if machine is off?
					# ask it to caculate its off time and return last datum timestamp and time
					# add to date_offtime variable
				time_difference = 0
				
				if dat.id < last_compared_id
					next
				end
				
				if dat.state == "off"	
					next_on_datum     = current_date_datums.where("state =? and id >?" , "on" , dat.id).order('timestampe asc').limit(1)

					if next_on_datum.count == 0
						next_on_datum   = Array[current_date_datums.last]
					end

					datum_chunk_range = current_date_datums.where("id>? and id<=?", dat.id, next_on_datum.first.id)

					#loop here to see time diff of consecutive values
					#if it is >3 then move pivot to that point
					date_pivot = dat.timestampe.to_i
					last_value = date_pivot
					
						datum_chunk_range.each do |d_chunk|
							#debugger
							d_chunk_diff = (d_chunk.timestampe.to_i - last_value)/60000
							

							if d_chunk_diff >= 3
								d = last_value - date_pivot
								d = d/60000 #in minutes
								if d > date_maximum_cont_off_time 
									date_maximum_cont_off_time = d
								end

								date_offtime = date_offtime + d

								date_pivot = d_chunk.timestampe.to_i
								d = 0
							end

							last_value = d_chunk.timestampe.to_i
						end
					

					if next_on_datum.count > 0
						time_difference  	= (next_on_datum.first.timestampe.to_i - date_pivot)/60000
						last_compared_id 	= next_on_datum.first.id

						 if time_difference > date_maximum_cont_off_time || date_maximum_cont_off_time == -1
						 	date_maximum_cont_off_time = time_difference
						 end

						date_offtime = date_offtime + time_difference
					end
				elsif dat.state == "on"

					next_off_datum   = current_date_datums.where("state =? and id >?" , "off" , dat.id).limit(1)
					
					if next_off_datum.count == 0
						next_off_datum   = Array[current_date_datums.last]
					end

					 datum_chunk_range = current_date_datums.where("id>? and id<=?", dat.id, next_off_datum.first.id)

					date_pivot = dat.timestampe.to_i
					last_value = date_pivot

					
						datum_chunk_range.each do |d_chunk|
							d_chunk_diff = (d_chunk.timestampe.to_i - last_value)/60000
							
							if d_chunk_diff >= 3

								d = last_value - date_pivot
								d = d/60000

								if d > date_maximum_cont_on_time 
									date_maximum_cont_on_time = d
								end

								date_pivot = d_chunk.timestampe.to_i
								d = 0
							end
							last_value    = d_chunk.timestampe.to_i
						end
				

					if next_off_datum.count > 0
						time_difference  	= (next_off_datum.first.timestampe.to_i - date_pivot)/60000
						last_compared_id 	= next_off_datum.first.id

						if time_difference > date_maximum_cont_on_time || date_maximum_cont_on_time == -1
							date_maximum_cont_on_time = time_difference
						end
					else
						#find difference till last time.
					end
				end
			}
			# save this date | offtime in its offtime table
			#debugger
			offtime 					  = self.offtimes.where(date: date).first_or_initialize
			offtime.minutes 			  = date_offtime
			offtime.maximum_cont_off_time = date_maximum_cont_off_time
			offtime.maximum_cont_on_time  = date_maximum_cont_on_time
			offtime.efficiency			  = self.efficiency(date)
			offtime.timestampe            = date.strftime('%s').to_i * 1000
			#offtime = self.offtimes.build(:date => date, :minutes => date_offtime)
			offtime.save!

		}
	end

	
	def getdata_for_graph

		if self.data_type == "Temperature" or self.data_type == "Current" or self.data_type == "Counter"
			data_json = datums.order('timestampe asc').pluck(:timestampe,:numbere)
			#data_json = data_json.map { |k,v| [k.to_f,v.to_f]}
				
		elsif self.data_type == "Rpm"
			data_json = datums.order('timestampe asc').pluck(:timestampe,:gradient)
			data_json = data_json.map { |k,v| [k.to_f,v.to_f]}
		end

		data_json
	
	end

	def getofftimes_for_graph
		data_offtimes = self.offtimes.order('timestampe asc').pluck(:timestampe,:efficiency)
		data_offtimes = data_offtimes.map { |k,v| [k.to_f,v] }
	end

	def fetch_data_from_excel
		google_drive_session

	    if self.next_index_excel >= @data_file.last_row
	    	return
		end

		last_date_visited = "2000-01-01".to_datetime.strftime('%s').to_i * 1000
		last_row 		  =  @data_file.last_row

		
		previous_datum = nil

		#variables for counter graph
		counter_pivot_point = 0
		add_offset_values	= 0
		counter_raw_previous_value = 0
		

	  	Datum.transaction do
	  		
		    header = @data_file.row(1)
			(self.next_index_excel..last_row).each do |i|

			row = Hash[[header, @data_file.row(i)].transpose]

			d 			 = Datum.new
			d.timee 	 = row["Time"]
			d.datee 	 = row["Date"]
			d.numbere 	 = row["Number"]
			d.typee		 = row["Type"]
			d.timestampe = row["Timestamp"]
			#debugger
			if d.timee.blank? or d.datee.blank? or d.numbere.blank? or d.typee.blank? or d.timestampe.blank?
				next
			end
			
			if self.data_type == "Rpm"
				# if d.numbere == 9532
				# 	debugger
				# end
				#find gradient
				if previous_datum.present?
					
					dy = (d.numbere - previous_datum.numbere) * 60000
					dx = d.typee.to_f - previous_datum.typee.to_f

					if dx > 0
						d.gradient = (dy.to_f/dx.to_f).round(2)
					else
						#resetting
						previous_datum.numbere = 0
						previous_datum.typee   = 0
						next
					end
				else
					d.gradient = 0
				end
				
			elsif self.data_type == 'Counter'
			    #reset value at 12am and 12 pm i.e after every 12 hours
				#debugger

				if d.numbere == 0
					#update offset with previous value
					add_offset_values = add_offset_values + counter_raw_previous_value
					counter_raw_previous_value = row["Number"].to_f
					next
				end

				d.numbere  = d.numbere + add_offset_values - counter_pivot_point
				d.gradient = row["Number"].to_f - counter_raw_previous_value
				original   = row["Time"].to_datetime.beginning_of_minute.strftime('%s').to_i/60  # timestamp in minutes
				day_end    = "23:59:59".to_datetime.beginning_of_minute.strftime('%s').to_i/60  # timestamp in minutes
				mid_day    = "12:00:00".to_datetime.beginning_of_minute.strftime('%s').to_i/60 # timestamp in minutes

				if (mid_day - original == 0 or day_end - original == 0)
					# reset counter
					# update pivot 
					counter_pivot_point = row["Number"].to_f
					d.numbere = 0
					add_offset_values   = 0
				end	

				counter_raw_previous_value = row["Number"].to_f
			end

			d.machine_id    = self.id
			d.timee 		= d.timee.beginning_of_minute

			timestamp    = row["Date"]+' '+ row["Time"]
			timestamp    = timestamp.to_datetime.beginning_of_minute.strftime('%s').to_i * 1000
			d.timestampe = timestamp
			
			if d.numbere < self.threshold
				d.state = "off"
			else
				d.state = "on"
			end


			if d.timestampe.to_i > last_date_visited.to_i
				d.save!
				last_date_visited = d.timestampe.to_i
				previous_datum = d
			end

			end
		end
		#update the next index to be used next time
		self.next_index_excel = last_row
		self.save!

	end


	def has_data
		if self.datums.count <= 0
			return false
		else
			return true
		end
	end

	def all_dates
		self.datums.uniq.pluck(:datee)
	end

	def get_offdatums
		self.datums.find_by(:state => "off")
	end

	# new implementation methods - don't delete them while cleansing.
	def load_offtimes
		processor = OfftimeProcessor.new(self.specific)
		processor.find_offtimes
	end
	
end
