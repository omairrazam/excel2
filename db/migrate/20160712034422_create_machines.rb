class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
    	
      t.belongs_to :user
      t.string :name
      t.timestamps null: false
    end
  end
end
