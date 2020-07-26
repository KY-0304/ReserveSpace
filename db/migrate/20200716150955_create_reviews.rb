class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :space, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :rate, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end
