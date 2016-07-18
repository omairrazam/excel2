class AddTimestampToData < ActiveRecord::Migration
  def change
  	add_column :data,:Timestamp, :datetime
  end
end
