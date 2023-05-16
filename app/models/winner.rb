class Winner < ApplicationRecord

  include AASM

  belongs_to :admin, class_name:'User', optional: true
  belongs_to :user
  belongs_to :item
  belongs_to :bet

  mount_uploader :picture, ImageUploader

  aasm column: :state do
    state :won, initial: true
    state :claimed, :submitted, :paid, :shipped, :delivered, :shared, :published, :remove_published

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: :shared, to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
    end
  end

  scope :filter_by_serial, ->(serial) { where(serial_number: serial ) }
  scope :filter_by_email, ->(email) { where(user: User.where(email: email) ) }
  scope :filter_by_state, ->(state) { where(state: state ) }
  scope :filter_by_start_date, ->(start_date) { where('created_at >=? ', Date.parse(start_date).beginning_of_day) }
  scope :filter_by_end_date, ->(end_date) { where('created_at <=?', Date.parse(end_date).end_of_day) }

end
