class AddGradientToDatums < ActiveRecord::Migration
  def change
    add_column :data, :gradient, :float
  end
end
