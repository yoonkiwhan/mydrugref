class ChangeCost < ActiveRecord::Migration
  def self.up
    change_column :posts, :cost, :float
  end

  def self.down
    change_column :posts, :cost, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
