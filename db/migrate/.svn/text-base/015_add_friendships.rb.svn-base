class AddFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships, :id => false do |t|
      t.column :user_id, :integer, :null => false
      t.column :friend_id, :integer, :null => false
      t.column :created_at, :datetime
  end
  
  add_index :friendships, [:user_id, :friend_id], :name => "index_friendships_on_user_id_and_friend_id"
  end
  
  def self.down
  drop_table :friendships
  end
end
