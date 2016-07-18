class CreateOfftimes < ActiveRecord::Migration
  def change
    create_table :offtimes do |t|
      t.date :date
      t.integer :minutes
      t.belongs_to :machine

      t.timestamps null: false
    end
  end
end
