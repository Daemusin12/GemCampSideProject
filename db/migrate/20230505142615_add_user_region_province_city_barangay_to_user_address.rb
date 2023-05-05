class AddUserRegionProvinceCityBarangayToUserAddress < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_addresses, :user
    add_reference :user_addresses, :address_region
    add_reference :user_addresses, :address_province
    add_reference :user_addresses, :address_city
    add_reference :user_addresses, :address_barangay
  end
end
