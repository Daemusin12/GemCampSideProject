class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.belongs_to :item
      t.belongs_to :bet
      t.belongs_to :user
      t.belongs_to :user_address
      t.integer :item_batch_count
      t.string :state
      t.decimal "price", precision: 18, scale: 2, default: "0.0"
      t.datetime :paid_at
      t.belongs_to :admin
      t.string :picture
      t.string :comment
      t.timestamps
    end
  end
end
