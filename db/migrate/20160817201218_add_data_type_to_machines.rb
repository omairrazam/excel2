class AddDataTypeToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :data_type, :string
  end
end
