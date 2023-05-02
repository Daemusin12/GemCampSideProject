class AddUsersRegionProvincesCitiesBarangaysToUserAddresses < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_addresses, :users
    add_reference :user_addresses, :address_regions
    add_reference :user_addresses, :address_provinces
    add_reference :user_addresses, :address_cities
    add_reference :user_addresses, :address_barangays
  end
end
