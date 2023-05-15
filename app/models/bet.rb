class Bet < ApplicationRecord

  include AASM

  belongs_to :user
  belongs_to :item
  validate :check_user_coins

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

  def check_user_coins
    if self.user.coins <= 0
      self.errors.add(:coins, "Not enough coins")
    end
  end

  scope :filter_by_item, ->(item) { where(item: Item.where(name: item) ) }
  scope :filter_by_email, ->(email) { where(user: User.where(email: email) ) }
  scope :filter_by_state, ->(state) { where(state: state ) }
  scope :filter_by_serial, ->(serial) { where(serial_number: serial ) }
  scope :filter_by_start_date, ->(start_date) { where('created_at >=? ', Date.parse(start_date).beginning_of_day) }
  scope :filter_by_end_date, ->(end_date) { where('created_at <=?', Date.parse(end_date).end_of_day) }
end

