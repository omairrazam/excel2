class AddMachineToData < ActiveRecord::Migration
  def change
    add_reference :data, :machine, index: true, foreign_key: true
  end
end
