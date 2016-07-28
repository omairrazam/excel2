class ChangeTimestampTypeToDatum < ActiveRecord::Migration
  def change
  	change_column :data, :timestampe,:string
  end
end
