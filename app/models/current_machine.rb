class CurrentMachine < ActiveRecord::Base
	acts_as :machine, validates_actable: false

	def process
		data = RawDatum.machine_data(self.next_index_excel, Constant::MACHINE_CURRENT,	self.unique_id)
		
		bulk_import_datums(data)
		# first row for next fetching
		self.next_index_excel = data.last.id if data.present?
		self.save

		if self.datums.count > 0
			process_offtimes
		end
	end

	def efficiency(date, hour=nil)
		selected_datums = self.datums.find_by_date(date)

		if hour.present?
			selected_datums = selected_datums.by_hour(hour)
		end

		total_datums    = selected_datums.count
		on_datums       = selected_datums.find_by_state('on').count.to_f
		efficiency = 0
		if total_datums > 0
			efficiency  = on_datums.to_f/total_datums * 100 
		end
	    efficiency.round(2)
	end

	def getdata_for_graph(date = self.datums.last.datee)
		datums.find_by_date(date).order('timestampe asc').pluck(:timestampe,:numbere)	
	end

	private

	def bulk_import_datums(data)
		all_data = []
		# currently processing is same as Temperature
		# will create its own processor in future if required
		processor  = TemperatureMachineProcessor.new(self)
		last_datum = self.datums.last 
		data.each do |row|
			d = processor.process_raw_datum(row,last_datum)
			if d.present?
				all_data << d 
				last_datum = d
			end
		end
		Datum.import all_data
	end
end
