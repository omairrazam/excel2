class AddNextIndexExcelToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :next_index_excel, :integer
  end
end
