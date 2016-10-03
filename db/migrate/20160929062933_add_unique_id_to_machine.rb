class AddUniqueIdToMachine < ActiveRecord::Migration
  def change
    add_column :machines, :unique_id, :string
  end
end
