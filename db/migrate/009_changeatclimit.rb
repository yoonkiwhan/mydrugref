class Changeatclimit < ActiveRecord::Migration
  def self.up
    change_column :posts, :atc, :string, :limit => 10
    change_column :posts, :atc2, :string, :limit => 10
  end

  def self.down
    change_column :posts, :atc, :string, :limit => 7
    change_column :posts, :atc2, :string, :limit => 7
  end
end
