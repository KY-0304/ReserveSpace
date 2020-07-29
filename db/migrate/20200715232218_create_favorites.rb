class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user,  foreign_key: true, index: false, null: false
      t.references :space, foreign_key: true, index: false, null: false

      t.timestamps
    end
    add_index :favorites, [:user_id, :space_id], unique: true
  end
end
