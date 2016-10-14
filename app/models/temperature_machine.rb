class TemperatureMachine < ActiveRecord::Base
	acts_as :machine, validates_actable: false
	scope   :getdata_for_graph, ->{datums.order('timestampe asc').pluck(:timestampe,:numbere)}

	def process
		data = RawDatum.machine_data(self.next_index_excel, Constant::MACHINE_TEMPERATURE,	self.unique_id)
		
		bulk_import_datums(data)
		# first row for next fetching
		self.next_index_excel = data.last.id if data.present?
		self.save

		if self.datums.count > 0
			process_offtimes
		end
	end

	def efficiency(date)
		selected_datums = datums.find_by_date(date)
		total_datums    = selected_datums.count
		on_datums       = selected_datums.find_by_state('on').count.to_f
		#debugger
		efficiency = 0
		if total_datums > 0
		 efficiency  = on_datums.to_f/total_datums * 100 
	    end
	    efficiency.round(2)
	end

	def getdata_for_graph
		datums.order('timestampe asc').pluck(:timestampe,:numbere)	
	end
	
	private

	def bulk_import_datums(data)
		all_data = []
		processor = TemperatureMachineProcessor.new(self)
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