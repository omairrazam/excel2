class ChangeTimestampeColumntypeOfOfftimes < ActiveRecord::Migration
  def change
  	remove_column :offtimes, :timestampe
  	add_column :offtimes, :timestampe, :bigint
  end
end
