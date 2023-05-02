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

  enum genre: { home: 0, office: 1 }

  def address_per_user
    address_count = UserAddress.where(users_id: (self.users_id)).count
    if address_count >= 5
      self.errors.add(:users_id, "max address per user reached")
    end
  end
end
