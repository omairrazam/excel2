class AddSendReportsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_reports, :boolean, :default => false
  end
end
