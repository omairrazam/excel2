class ChangeTimestampTypeToDatumBigint < ActiveRecord::Migration
  def change
  	remove_column :data, :timestampe
  end
end
