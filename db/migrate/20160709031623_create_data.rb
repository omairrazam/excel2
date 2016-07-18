class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.date :date
      t.time :time
      
      t.float :number
      t.string :typ

      t.timestamps null: false
    end
  end
end
