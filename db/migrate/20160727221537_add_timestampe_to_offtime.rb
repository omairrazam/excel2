class AddTimestampeToOfftime < ActiveRecord::Migration
  def change
    add_column :offtimes, :timestampe, :string
  end
end
