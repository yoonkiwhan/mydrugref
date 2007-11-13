class AlterSignificance < ActiveRecord::Migration
  def self.up
    change_column :posts, :significance, :string, :limit => 1
  end

  def self.down
    change_column :posts, :significance, :integer
  end
end
