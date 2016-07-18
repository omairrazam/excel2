class AddIndexToDateOfData < ActiveRecord::Migration
  def change
    add_index :data, :date
  end
end
