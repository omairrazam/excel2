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

	def max_continuous_off_time
		hrs   = maximum_cont_off_time / 60
		mins  = maximum_cont_off_time % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end

	def max_continuous_on_time
		hrs   = maximum_cont_on_time / 60
		mins  = maximum_cont_on_time % 60
		final = hrs.to_s + "h " + mins.to_s + "m"
	end
end
