class ChangeFldrug1 < ActiveRecord::Migration
  def self.up
    rename_column :posts, :fldrug1, :FLD1
  end

  def self.down
    rename_column :posts, :FLD1, :fldrug1
  end
end
