class UserAddress < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validate :address_per_user, on: :create

  enum genre: { home: 0, office: 1 }

  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  def address_per_user
    address_count = UserAddress.where(user_id: (self.user_id)).count
    if address_count >= 5
      self.errors.add(:user_id, "max address per user reached")
    end
  end
end
