class UserAddress < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  enum genre: { home: 0, office: 1 }
end
