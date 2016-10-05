class CounterMachine < ActiveRecord::Base
	acts_as :machine, validates_actable: false
    scope   :getdata_for_graph, ->{datums.order('timestampe asc').pluck(:timestampe,:numbere)}

	def process
		data = RawDatum.machine_data(self.next_index_excel, Constant::MACHINE_COUNTER,	self.unique_id)
		bulk_import_datums(data)
		# first row for next fetching
		self.next_index_excel = data.last.id if data.present?
		self.save

		
		if self.datums.count > 0
			load_offtimes
		end
	end

	def efficiency(date)
		selected_datums = datums.find_by_date(date)
		total_datums    = selected_datums.count
		on_datums       = selected_datums.find_by_state('on').count.to_f

		zero_gradients_count = selected_datums.find_by_gradient(0).count
		efficiency      	 = (total_datums - zero_gradients_count).to_f/total_datums * 100
		efficiency.round(2)
	end

	private

	def bulk_import_datums(data)
		all_data = []
		processor = CounterMachineProcessor.new(self)
		data.each do |row|
			d = processor.process_raw_datum(row)
			all_data << d if d.present?
		end
		Datum.import all_data
	end
end
