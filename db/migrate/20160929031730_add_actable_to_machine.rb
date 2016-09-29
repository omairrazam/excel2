class AddActableToMachine < ActiveRecord::Migration
  change_table :machines do |t|
  	t.integer :actable_id
  	t.string  :actable_type
  end
end
