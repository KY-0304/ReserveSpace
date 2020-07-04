class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.references :owner, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :image
      t.string :address, null: false
      t.string :phone_number
      t.binary :hourly_price, null: false
      t.time :business_start_time, null: false
      t.time :business_end_time, null: false

      t.timestamps
    end
    add_index :rooms, :address
    add_index :rooms, :hourly_price
    add_index :rooms, :business_start_time
    add_index :rooms, :business_end_time
  end
end
