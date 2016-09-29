class CreateRpmMachines < ActiveRecord::Migration
  def change
    create_table :rpm_machines do |t|
      t.float :grad
    end
  end
end
