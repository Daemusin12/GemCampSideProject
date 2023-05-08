class AdminController < ApplicationController
  def index
    @users = User.where(role: 0)
  end
end
