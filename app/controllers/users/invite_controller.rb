class Users::InviteController < ApplicationController
  before_action :set_user

  def index
    @qr_code = qr_code(@user)
  end

  def qr_code(user)
    require "rqrcode"

    qrcode = RQRCode::QRCode.new(new_user_registration_path(host: 'client.com', promoter: user.email))
    svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
    return svg

  end

  def set_user
    @user = current_user
  end
end

