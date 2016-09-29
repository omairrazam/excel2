class CreateCounterMachines < ActiveRecord::Migration
  def change
    create_table :counter_machines do |t|

      t.timestamps null: false
    end
  end
end
