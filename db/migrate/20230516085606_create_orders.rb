class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :offer
      t.string :serial_number
      t.string :state
      t.decimal "amount", precision: 18, scale: 2, default: "0.0"
      t.integer "coins", default: 0
      t.string :remarks
      t.integer "genre", default: 0
      t.timestamps
    end
  end
end
