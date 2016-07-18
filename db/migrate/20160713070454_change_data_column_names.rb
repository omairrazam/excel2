class ChangeDataColumnNames < ActiveRecord::Migration
  def change
  	remove_column :data, :date
  	add_column :data,:Date, :date
  	rename_column :data, :time, :Time
  	rename_column :data, :number, :Number
  	rename_column :data, :typ, :Type
  end
end
