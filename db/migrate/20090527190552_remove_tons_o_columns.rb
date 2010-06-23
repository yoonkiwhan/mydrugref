class RemoveTonsOColumns < ActiveRecord::Migration
  def self.up
    remove_column :posts, :atc
    remove_column :posts, :drug2
    remove_column :posts, :atc2
    remove_column :posts, :FLD1
    remove_column :posts, :fldrug3
    remove_column :posts, :sldrug1
    remove_column :posts, :sldrug2
    remove_column :posts, :sldrug3
    remove_column :posts, :pregdrug1
    remove_column :posts, :pregdrug2
    remove_column :posts, :pregdrug3
    remove_column :posts, :atc3
    remove_column :posts, :slatc
    remove_column :posts, :slatc2
    remove_column :posts, :slatc3
    remove_column :posts, :pregatc
    remove_column :posts, :pregatc2
    remove_column :posts, :pregatc3
    remove_column :posts, :din
  end

  def self.down
    add_column :posts, :atc, :string
    add_column :posts, :drug2, :string
    add_column :posts, :atc2, :string
    add_column :posts, :FLD1, :string
    add_column :posts, :fldrug3, :string
    add_column :posts, :sldrug1, :string
    add_column :posts, :sldrug2, :string
    add_column :posts, :sldrug3, :string
    add_column :posts, :pregdrug1, :string
    add_column :posts, :pregdrug2, :string
    add_column :posts, :pregdrug3, :string
    add_column :posts, :atc3, :string
    add_column :posts, :slatc, :string
    add_column :posts, :slatc2, :string
    add_column :posts, :slatc3, :string
    add_column :posts, :pregatc, :string
    add_column :posts, :pregatc2, :string
    add_column :posts, :pregatc3, :string
    add_column :posts, :din, :string
  end
end
