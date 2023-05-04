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

  enum role: { client: 0, admin: 1 }

  mount_uploader :image, ImageUploader

  def invite_link
    "http://client.com:3000/users/sign_up?promoter=#{self.email}"
  end

  def qr_code
    require "rqrcode"

    qrcode = RQRCode::QRCode.new(self.invite_link)
    svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
    return svg
  end

end
