class GoatVote < ActiveRecord::Migration
  def self.up
    add_column :posts, :goat, :boolean
  end

  def self.down
    remove_column :posts, :goat, :boolean
  end
end
