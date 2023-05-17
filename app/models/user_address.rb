class UserAddress < ApplicationRecord
  before_update :set_default_address
  after_commit :default_address, on: [:create, :destroy]
  validates :name, presence: true, uniqueness: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validate :address_per_user, on: :create
  # validate :default_address, on: :create

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

  def set_default_address
    UserAddress.where(user_id: (self.user_id)).update_all(is_default: false)
  end

  def default_address
    address_count = UserAddress.where(user_id: (self.user_id)).count
    if address_count == 1
      UserAddress.where(user_id: (self.user_id)).update(is_default: true)
    end
  end

  def address_concatenation
    "#{street_address}, #{region&.name}, #{province&.name}, #{city&.name}, #{barangay&.name}"
  end

end
