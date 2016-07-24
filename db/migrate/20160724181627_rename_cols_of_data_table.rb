class RenameColsOfDataTable < ActiveRecord::Migration
  def change

  	rename_column :data, :Time, :timee
  	rename_column :data, :Number, :numbere
  	rename_column :data, :Type, :typee
  	rename_column :data, :Date, :datee
  	rename_column :data, :Timestamp, :timestampe

  end
end
