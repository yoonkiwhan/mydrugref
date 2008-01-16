class AddName < ActiveRecord::Migration
  def self.up
     add_column :threaded_discussion_posts, :name, :string
  end

  def self.down
     remove_column :threaded_discussion_posts, :name
  end
end
