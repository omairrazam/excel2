class Datum < ActiveRecord::Base
  scope :find_by_date,     ->(date){where(datee: date)}	
  scope :find_by_state,    ->(state){where(state: state)}
  scope :find_by_gradient, ->(gradient){where(gradient: gradient)}
  belongs_to :machine
  
end
