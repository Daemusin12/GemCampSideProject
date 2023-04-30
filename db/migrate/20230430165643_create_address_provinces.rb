class CreateAddressProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :address_provinces do |t|
      t.belongs_to :region
      t.string :name
      t.string :code
      t.timestamps
    end
  end
end
