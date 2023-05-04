class Users::InviteController < ApplicationController
  def index
    @user = current_user
  end
end
