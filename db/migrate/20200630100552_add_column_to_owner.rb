class AddColumnToOwner < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :company_name, :string, null: false
    add_index :owners, :company_name, unique: true
  end
end
