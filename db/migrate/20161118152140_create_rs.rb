class CreateRs < ActiveRecord::Migration
  def change
    create_table :thedata do |t|
      t.date :date
      t.time :time
      t.integer :sensor_id
      t.integer :sensor_type
      t.float :sensor_value
      t.integer :millis

      t.timestamps null: false
    end
  end
end
