class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  belongs_to :parent, class_name:'User', optional: true, counter_cache: :children_members
  has_many :children, class_name:'User', foreign_key: 'parent_id'
  has_many :bets
  has_many :winners
  has_many :winners, foreign_key: 'admin_id'

  enum role: { client: 0, admin: 1 }

  mount_uploader :image, ImageUploader

  def members_deposit
    children.sum(:total_deposit)
  end

end
