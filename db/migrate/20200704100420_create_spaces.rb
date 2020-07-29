class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.references :owner,               null: false, foreign_key: true
      t.string     :name,                null: false
      t.string     :phone_number,        null: false
      t.integer    :hourly_price,        null: false
      t.time       :business_start_time, null: false
      t.time       :business_end_time,   null: false
      t.integer    :postcode,            null: false
      t.integer    :prefecture_code,     null: false
      t.string     :address_city,        null: false
      t.string     :address_street,      null: false
      t.string     :address_building
      t.text       :description
      t.json       :images

      t.timestamps
    end
    add_index :spaces, :postcode
    add_index :spaces, :prefecture_code
    add_index :spaces, :address_city
    add_index :spaces, :address_street
    add_index :spaces, :address_building
    add_index :spaces, :hourly_price
    add_index :spaces, :business_start_time
    add_index :spaces, :business_end_time
  end
end
