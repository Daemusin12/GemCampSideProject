class UserAddress < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validate :address_per_user, on: :create

  belongs_to :users, class_name: 'User', foreign_key: 'users_id'
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_regions_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_provinces_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_cities_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangays_id'

  enum genre: { home: 0, office: 1 }

  def address_per_user
    address_count = UserAddress.where(users_id: (self.users_id)).count
    if address_count >= 5
      self.errors.add(:users_id, "max address per user reached")
    end
  end
end
