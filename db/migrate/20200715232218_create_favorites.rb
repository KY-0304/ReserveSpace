class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false

      t.timestamps
    end
    add_index :favorites, [:user_id, :room_id], unique: true
  end
end
