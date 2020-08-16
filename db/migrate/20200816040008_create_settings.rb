class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.references :space,        null: false, foreign_key: true
      t.boolean    :unacceptable, null: false, defalut: false
      t.datetime   :unacceptable_start_time
      t.datetime   :unacceptable_end_time

      t.timestamps
    end
  end
end
