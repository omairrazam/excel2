class CreateRawData < ActiveRecord::Migration
  def change

    create_table :raw_data do |t|
      t.date :date
      t.time :timee
      t.string :machine_id, index: true
      t.float :numbere
      t.string :typee
      t.string :timestampe
      t.string :machine_type, index: true


      t.timestamps null: false
    end


  end
end
