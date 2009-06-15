class MakeDinString < ActiveRecord::Migration
  def self.up
    change_column :drug_refs, :drug_identification_number, :string
  end

  def self.down
    change_column :drug_refs, :drug_identification_number, :integer
  end
end
