class CreateEForms < ActiveRecord::Migration
  def self.up
    create_table :e_forms do |t|
      t.column :name, :string
      t.column :category, :string
      t.column :created_by, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :e_forms
  end
end
