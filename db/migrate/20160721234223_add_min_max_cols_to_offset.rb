class AddMinMaxColsToOffset < ActiveRecord::Migration
  def change
  	add_column :offtimes,:maximum_cont_on_time,  :integer
  	add_column :offtimes,:maximum_cont_off_time, :integer
  end
end
