class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.references :owner, foreign_key: true, index: true
      t.string :name, null: false
      t.text :description
      t.string :image, null: false
      t.integer :postcode, null: false
      t.integer :prefecture_code, null: false
      t.string :address_city, null: false
      t.string :address_street, null: false
      t.string :address_building, null: false
      t.string :phone_number, null: false
      t.integer :hourly_price, null: false
      t.time :business_start_time, null: false
      t.time :business_end_time, null: false

      t.timestamps
    end
    add_index :rooms, :postcode
    add_index :rooms, :prefecture_code
    add_index :rooms, :address_city
    add_index :rooms, :address_street
    add_index :rooms, :address_building
    add_index :rooms, :hourly_price
    add_index :rooms, :business_start_time
    add_index :rooms, :business_end_time
  end
end
