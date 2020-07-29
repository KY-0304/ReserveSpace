class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name,         :string,  null: false
    add_column :users, :phone_number, :string,  null: false
    add_column :users, :gender,       :integer, null: false, default: 0
  end
end
