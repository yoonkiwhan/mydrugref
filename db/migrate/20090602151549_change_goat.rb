class ChangeGoat < ActiveRecord::Migration
  def self.up
    rename_column :posts, :goat, :agree
  end

  def self.down
    rename_column :posts, :agree, :goat
  end
end
