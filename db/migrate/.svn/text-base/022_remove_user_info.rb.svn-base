class RemoveUserInfo < ActiveRecord::Migration
  def self.up
    remove_column :users, :phone
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip
  end

  def self.down
    add_column :users, :phone, :string,   :limit => 50,  :default => "",    :null => false
    add_column :users, :address, :string,   :limit => 50,  :default => "",    :null => false
    add_column :users, :city, :string,   :limit => 50,  :default => "",    :null => false
    add_column :users, :state, :string,   :limit => 50,  :default => "",    :null => false
    add_column :users, :zip, :string,   :limit => 50,  :default => "",    :null => false
  end
end
