class RpmMachine < ActiveRecord::Base
	acts_as :machine, validates_actable: false

	def process
		p "RPM machine processing"
	end

end
