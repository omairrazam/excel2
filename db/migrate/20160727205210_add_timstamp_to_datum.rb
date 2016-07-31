class AddTimstampToDatum < ActiveRecord::Migration
  def change
    add_column :data, :timestampe, :string
  end
end
