class Bet < ApplicationRecord

  include AASM

  belongs_to :user
  belongs_to :item

  after_create :assign_serial_number, :deduct_coins

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :won do
      transitions from: :betting, to: :won
    end

    event :lost do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, after: :refund_coins
    end

  end

  def assign_serial_number
    number_count = Bet.where(item: item, batch_count: item.batch_count).count
    self.update(serial_number: "#{Time.current.strftime("%Y%m%d")
    }-#{item.id}-#{item.batch_count}-#{sprintf '%04d', number_count}")
  end

  def deduct_coins
    self.user.update(coins: self.user.coins - self.coins)
  end

  def refund_coins
    self.user.update(coins: self.user.coins + self.coins)
  end

end
