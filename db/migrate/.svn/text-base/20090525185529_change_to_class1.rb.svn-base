class ChangeToClass1 < ActiveRecord::Migration
  def self.up
    rename_column :cd_drug_product, :class, :class_1
  end

  def self.down
    rename_column :cd_drug_product, :class_1, :class
  end
end
