class AddTrusted < ActiveRecord::Migration
  def self.up
    add_column :posts, :trusted, :boolean
  end

  def self.down
    remove_column :posts, :trusted, :boolean
  end
end
