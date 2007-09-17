class TreatmentsCriteria < ActiveRecord::Migration
  def self.up
    add_column :posts, :fldrug1, :string
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
  end

  def self.down
    remove_column :posts, :fldrug1, :string
    remove_column :posts, :fldrug3, :string
    remove_column :posts, :sldrug1, :string
    remove_column :posts, :sldrug2, :string
    remove_column :posts, :sldrug3, :string
    remove_column :posts, :pregdrug1, :string
    remove_column :posts, :pregdrug2, :string
    remove_column :posts, :pregdrug3, :string
    remove_column :posts, :atc3, :string
    remove_column :posts, :slatc, :string
    remove_column :posts, :slatc2, :string
    remove_column :posts, :slatc3, :string
    remove_column :posts, :pregatc, :string
    remove_column :posts, :pregatc2, :string
    remove_column :posts, :pregatc3, :string
  end
end
