class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.references :space,                       null: false, foreign_key: true
      t.boolean    :reject_same_day_reservation, null: false, default: false
      t.boolean    :reservation_unacceptable,    null: false, default: false
      t.date       :reservation_unacceptable_start_date
      t.date       :reservation_unacceptable_end_date

      t.timestamps
    end
  end
end
