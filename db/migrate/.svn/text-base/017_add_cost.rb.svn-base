class AddCost < ActiveRecord::Migration
  def self.up
    add_column :posts, :cost, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    remove_column :posts, :cost
  end
end
