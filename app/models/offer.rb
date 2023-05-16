class Offer < ApplicationRecord

  enum genre: { regular: 0, daily: 1, weekly: 2, monthly: 3, one_time: 4 }

  enum status: { inactive: 0, active: 1 }

  mount_uploader :image, ImageUploader

end
