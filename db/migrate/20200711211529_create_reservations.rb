class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :space, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
    add_index :reservations, :start_time, unique: true
    add_index :reservations, :end_time, unique: true
  end
end
