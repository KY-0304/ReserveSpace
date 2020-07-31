class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :space,   null: false, foreign_key: true
      t.references :user,    null: false, foreign_key: true
      t.integer    :rate,    null: false
      t.text       :comment, null: false

      t.timestamps
    end
  end
end
