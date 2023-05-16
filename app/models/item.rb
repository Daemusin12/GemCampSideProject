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
      transitions from: :starting, to: :ended, guard: :minimum_bets?, success: :set_winner
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, success: :cancel_bets
    end
  end

  def deduct_count_and_add_batch!
    update(quantity: self.quantity - 1)
    update(batch_count: self.batch_count + 1)
  end

  def quantity_enough?
    quantity >= 1 && Time.current <= offline_at && active?
  end

  def cancel_bets
    Bet.where(item: self, batch_count: self.batch_count).each {|bet| bet.cancel! if bet.may_cancel? }
  end

  def minimum_bets?
    @bet_count = Bet.where(item: self, batch_count: self.batch_count).count
    @bet_count >= self.minimum_bets
  end

  def set_winner
    @bets = Bet.where(item: self, batch_count: self.batch_count)
    winner_bet = @bets.sample
    winner_bet.win!
    @bets.each do | bet |
      unless bet.state == 'won'
        bet.lose!
      end
    end
    Winner.create(item: self, bet: winner_bet, user: winner_bet.user, item_batch_count: self.batch_count)
  end

  scope :filter_by_category, ->(selected_categories) { includes(:categories).where(categories: { name: selected_categories} ) }
end
