class ChangeSignificanceLimit < ActiveRecord::Migration
  def self.up
    change_column :posts, :significance, :string
  end

  def self.down
    change_column :posts, :significance, :string, :limit => 1
  end
end
