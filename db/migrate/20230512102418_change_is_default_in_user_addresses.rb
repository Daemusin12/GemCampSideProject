class ChangeIsDefaultInUserAddresses < ActiveRecord::Migration[7.0]
  def change
    change_column :user_addresses, :is_default ,:boolean, default: false
  end
end
