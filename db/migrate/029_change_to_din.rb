class ChangeToDin < ActiveRecord::Migration
  def self.up
    rename_column :drug_refs, :drug_code, :drug_identification_number
  end

  def self.down
    rename_column :drug_refs, :drug_identification_number, :drug_code
  end
end
