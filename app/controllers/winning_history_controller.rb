class WinningHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :validate_user_profile

  def index
    @user = current_user
    @wins = Winner.where(user: @user)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def validate_user_profile
    raise ActionController::RoutingError.new('Not Found') unless @user == current_user
  end
end
