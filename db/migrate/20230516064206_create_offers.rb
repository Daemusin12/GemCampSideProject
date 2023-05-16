class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.integer "genre", default: 0
      t.integer "status", default: 0
      t.decimal "amount", precision: 18, scale: 2, default: "0.0"
      t.integer "coins", default: 0
      t.timestamps
    end
  end
end
