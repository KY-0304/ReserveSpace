class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.float :rate, null: false, default: 0
      t.text :comment, limit: 100

      t.timestamps
    end
  end
end
