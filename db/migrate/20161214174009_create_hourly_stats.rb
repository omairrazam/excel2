class CreateHourlyStats < ActiveRecord::Migration
  def change
    create_table :hourly_stats do |t|
      t.integer :machine_id
      t.date :datee
      t.string :hour
      t.integer :total_datums
      t.string :total_uptime
      t.string :cont_ontime
      t.string :cont_offtime
      t.float :efficiency

      t.timestamps null: false
    end
  end
end
