class CounterMachine < ActiveRecord::Base
	acts_as :machine, validates_actable: false
	
	def process
		p "Counter machine processing"
	end

end
