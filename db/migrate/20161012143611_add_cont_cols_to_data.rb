class AddContColsToData < ActiveRecord::Migration
  def change
  	 add_column :data, :cont_on_time,  :bigint
  	 add_column :data, :cont_off_time, :bigint
  end
end
