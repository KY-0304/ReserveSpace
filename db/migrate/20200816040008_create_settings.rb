class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.references :space,                               null: false, foreign_key: true
      t.boolean    :date_range_reservation_unacceptable, null: false, default: false
      t.date       :reservation_unacceptable_start_day
      t.date       :reservation_unacceptable_end_day

      t.timestamps
    end
  end
end
