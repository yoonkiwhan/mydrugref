class OneVote < ActiveRecord::Migration
  def self.up
    remove_column :posts, :vote
    remove_column :posts, :agree
  end

  def self.down
    add_column :posts, :vote
    add_column :posts, :agree
  end
end
