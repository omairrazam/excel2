class AddNextIndexToMachine < ActiveRecord::Migration
  def change
    add_column :users, :next_index_excel, :integer, :default => 2
  end
end
