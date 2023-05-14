class Item < ApplicationRecord

  enum status: { inactive: 0, active: 1 }

  include AASM

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :bets, dependent: :restrict_with_error

  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting, guard: :quantity_enough?, success: :deduct_count_and_add_batch!
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def deduct_count_and_add_batch!
    update(quantity: self.quantity - 1)
    update(batch_count: self.batch_count + 1)
  end

  def quantity_enough?
    quantity >= 1 && Time.current <= offline_at && active?
  end

  scope :filter_by_category, ->(selected_categories) { includes(:categories).where(categories: { name: selected_categories} ) }
end
