class AddEfficiencyToOfftimes < ActiveRecord::Migration
  def change
    add_column :offtimes, :efficiency, :float
  end
end
