class AddRecurringColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recurring, :boolean, :default => true
    add_column :users, :period, :string, :default => "Month"
    add_column :users, :cycles, :integer, :default => 12
  end
end
