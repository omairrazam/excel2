class Offtime < ActiveRecord::Base
	belongs_to :machine

	def efficiency
		((1 - minutes.to_f/1440.0)*100).round(2)
	end

	def seconds
		minutes * 60
	end

	def convert_to_ontime_in_seconds
		(1440 - minutes) * 60
	end
end
