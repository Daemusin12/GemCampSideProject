class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :validate_user_profile

  def show; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def validate_user_profile
    raise ActionController::RoutingError.new('Not Found') unless @user == current_user
  end

end
