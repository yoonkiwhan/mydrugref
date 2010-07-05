class RemoveMorePostColumns < ActiveRecord::Migration
  def self.up
    remove_column :posts, :attachment_id
    remove_column :posts, :attachment_filename
    remove_column :posts, :attachment_content_type
    remove_column :posts, :attachment_size
    remove_column :posts, :trusted
  end

  def self.down
    add_column :posts, :attachment_id, :integer
    add_column :posts, :attachment_filename, :string
    add_column :posts, :attachment_content_type, :string
    add_column :posts, :attachment_size, :integer
    add_column :posts, :trusted, :boolean
  end
end
