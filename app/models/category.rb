class Category < ApplicationRecord
  validates :name, presence: true

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :items, through: :item_category_ships

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.now)
  end
end
