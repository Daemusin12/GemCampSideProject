class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city
  has_many :user_addresses, class_name: 'UserAddress', foreign_key: 'address_barangays_id'
end
