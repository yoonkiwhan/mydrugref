class NewsFields < ActiveRecord::Migration
  def self.up
  add_column :posts, :news_source, :string
  add_column :posts, :news_date, :string
  end

  def self.down
  remove_column :posts, :news_source, :string
  remove_column :posts, :news_date, :string
  end
end
