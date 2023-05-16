class Order < ApplicationRecord

  include AASM

  after_create :assign_serial_number

  belongs_to :user
  belongs_to :offer

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled, guard: :check_user_coins, success: [:cancel_is_deduct, :cancel_is_deposit]
    end

    event :pay do
      transitions from: :submitted, to: :paid, success: [:pay_is_deduct, :pay_is_deposit]
    end
  end

  def pay_is_deduct
    if deduct?
      user.update(coins: self.user.coins - self.coins)
    else
      user.update(coins: self.user.coins + self.coins)
    end
  end

  def pay_is_deposit
    if
      user.update(total_deposit: self.user.total_deposit + self.amount)
    end
  end

  def cancel_is_deduct
    if deduct?
      user.update(coins: self.user.coins + self.coins)
    else
      user.update(coins: self.user.coins - self.coins)
    end
  end

  def cancel_is_deposit
    if deposit?
      user.update(total_deposit: self.user.total_deposit - self.amount)
    end
  end

  def check_user_coins
    if self.user.coins < self.coins
      self.errors.add(:coins, "Not enough coins")
    end
  end

  def assign_serial_number
    number_count = Order.where(user: self.user).count
    self.update(serial_number: "#{Time.current.strftime("%Y%m%d")
    }-#{self.id}-#{self.user_id}-#{sprintf '%04d', number_count}")
  end

  scope :filter_by_serial, ->(serial) { where(serial_number: serial ) }
  scope :filter_by_email, ->(email) { where(user: User.where(email: email) ) }
  scope :filter_by_genre, ->(genre) { where(state: genre ) }
  scope :filter_by_state, ->(state) { where(state: state ) }
  scope :filter_by_offer, ->(state) { where(offer: Offer.where(name: state) ) }
  scope :filter_by_start_date, ->(start_date) { where('created_at >=? ', Date.parse(start_date).beginning_of_day) }
  scope :filter_by_end_date, ->(end_date) { where('created_at <=?', Date.parse(end_date).end_of_day) }
end
