class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :space,      null: false, foreign_key: true
      t.references :user,       null: false, foreign_key: true
      t.datetime   :start_time, null: false
      t.datetime   :end_time,   null: false

      t.timestamps
    end
    add_index :reservations, [:space_id, :start_time], unique: true
    add_index :reservations, [:space_id, :end_time],   unique: true
  end
end
