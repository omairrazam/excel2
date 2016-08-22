class AddThresholdAndSheetNameToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :threshold, :integer
    add_column :machines, :sheetname, :string
  end
end
