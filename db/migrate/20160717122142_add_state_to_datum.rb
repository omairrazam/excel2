class AddStateToDatum < ActiveRecord::Migration
  def change
  	add_column :data,:state, :string
  end
end
