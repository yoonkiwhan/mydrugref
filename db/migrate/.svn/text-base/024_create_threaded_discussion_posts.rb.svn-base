class CreateThreadedDiscussionPosts < ActiveRecord::Migration
  def self.up
    create_table :threaded_discussion_posts do |t|
      t.column "root_id", :integer
      t.column "parent_id", :integer
      t.column "lft", :integer
      t.column "rgt", :integer
      t.column "body", :text, :default => "",  :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :integer
      t.column "updated_by", :integer
    end
  end

  def self.down
    drop_table :threaded_discussion_posts
  end
end
