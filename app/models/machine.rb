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
	validates  :unique_id, presence: true
	#validates  :next_index_excel, presence: true

	#after_action :process_offtimes, only: :process
	
	def process_offtimes
		op = OfftimeProcessor.new(self.specific)
		op.process_new_datums
	end
end
