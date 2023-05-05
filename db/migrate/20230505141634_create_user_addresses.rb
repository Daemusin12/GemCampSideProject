class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.integer "genre", default: 0
      t.string "name"
      t.string "street_address"
      t.string "phone_number"
      t.string "remark"
      t.boolean "is_default"
      t.timestamps
    end
  end
end
