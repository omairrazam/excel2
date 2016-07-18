class AddSheetNameToUsers < ActiveRecord::Migration
  def change
  	add_column :users,:sheet_name, :string
  end
end
