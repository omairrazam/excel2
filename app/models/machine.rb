class Machine < ActiveRecord::Base
	#scope :average_by_day, -> date{ where(Date: date) if date.present?}
	belongs_to :user
	has_many   :datums , dependent: :destroy
	has_many   :offtimes , dependent: :destroy

	def update_offtimes
		#debugger
		offtime_last_date 	= self.offtimes.last.try(:date) 
		datum_first_date    = self.datums.first.datee
		starting_date  		= offtime_last_date

		if offtime_last_date.blank?
			starting_date   = datum_first_date
		end
		#debugger
		hash 		 = self.datums.all.where('datee>=?', starting_date).group_by{ |dat| dat.datee.to_date }
		last_visited = 0
		hash.each{|date,dats|
			# condition to check if this date is less than last_visited
			# then next
			# date_offtime variable = 0 
			date_offtime 		       = 0
			date_maximum_cont_on_time  = 0
			date_maximum_cont_off_time = -1

			current_date_datums = self.datums.all.where("datee=?",date)
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
						time_difference  	= next_on_datum.first.timee.minus_with_coercion(dat.timee)/60
						last_compared_id 	= next_on_datum.first.id

						
						if time_difference < date_maximum_cont_off_time || date_maximum_cont_off_time == -1
							date_maximum_cont_off_time = time_difference
						end

						date_offtime = date_offtime + time_difference
					end
				elsif dat.state == "on"
					next_on_datum   = current_date_datums.where("state =? and id >?" , "off" , dat.id).limit(1)
					
					if next_on_datum.count > 0
						time_difference  	= next_on_datum.first.timee.minus_with_coercion(dat.timee)/60
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

	def getdata_for_graph
		now  = self.datums.first.timestampe.beginning_of_minute.strftime('%s')
		now = now.to_i  * 1000
		 
		last_time  = 0
		data_json  =  self.datums.select(:id,:timestampe,:numbere).map{|m|
	 	t = m.timestampe.strftime('%s').to_i * 1000

		if t <= last_time 
			next
		end
	 	
	 	last_time = t
	 	Array.[](t, m.numbere)
		}.compact.to_json.to_s.html_safe
		data_json

		#debugger
	end

	def getofftimes_for_graph

		data_offtimes  =  self.offtimes.order('date ASC').select(:date,:minutes).map{|m|
		
		t = m.date.strftime('%s').to_i * 1000
	 	Array.[](t, (1440 - m.minutes)*100/1440)
		}.to_json.to_s.html_safe
		data_offtimes
		#debugger
	end

	def fetch_data_from_excel(ws,sheet_name,starting_index,current_user_machines)
		
		
		ws.export_as_file(Rails.root.to_s +  "/excelsheets/#{sheet_name}.csv")

		data_file = Roo::CSV.new(Rails.root.to_s + "/excelsheets/#{sheet_name}.csv")
	   

	    if starting_index >= data_file.last_row
	    	return
		end
		last_date_visited = DateTime.parse("2000-01-01 00:00:00").strftime('%s').to_i
	  	Datum.transaction do
		    header = data_file.row(1)
			(starting_index..data_file.last_row).each do |i|

			row = Hash[[header, data_file.row(i)].transpose]
			
			d 			 = Datum.new
			d.timee 	 = row["Time"]
			d.datee 	 = row["Date"]
			d.numbere 	 = row["Number"]
			d.typee		 = row["Type"]
			d.timestampe = row["Timestamp"]

			current_machine = current_user_machines.find{|m|m.name == row["ID"]}
			d.machine_id    = current_machine.id
			d.timee 		= d.timee.beginning_of_minute

			d.timestampe = row["Date"]+' '+ row["Time"]
			d.timestampe = d.timestampe.beginning_of_minute
			
			if d.numbere <= 10
					d.state = "off"
				else
					d.state = "on"
			end

			if d.timestampe.strftime('%s').to_i > last_date_visited
				d.save!
			end

			last_date_visited = d.timestampe.strftime('%s').to_i

			end
		end
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

	def average_value_by_day(date)
		 datums.where('datee=?', date).average(:numbere).to_f.round(2)
	end

	def maximum_value_by_day(date)
		 datums.where('datee=?', date).maximum(:numbere).to_f.round(2)
	end

	def minimum_value_by_day(date)
		 datums.where('datee=?', date).minimum(:numbere).to_f.round(2)
	end
end
