class ChangeColumnToData < ActiveRecord::Migration
  def change
  	remove_column :data, :timestampe
  	add_column :data, :timestampe, :bigint
  end
end
