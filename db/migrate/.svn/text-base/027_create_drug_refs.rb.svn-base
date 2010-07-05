class CreateDrugRefs < ActiveRecord::Migration
  def self.up
    create_table :drug_refs do |t|
      t.column :drug_code, :integer
      t.column :post_id,   :integer
      t.column :label,     :string
    end
  end

  def self.down
    drop_table :drug_refs
  end
end
