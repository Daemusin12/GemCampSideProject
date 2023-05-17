class WinningHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :validate_user_profile

  def index
    @user = current_user
    @wins = Winner.where(user: @user)
  end

  def edit
    @winner = Winner.where(user: current_user).find_by(params[:id])

  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])
    if @winner.update(user_address_params)
      @winner.claim!
      flash[:notice] = "Prize Claim was successfully updated"
    else
      flash[:alert] = @winner.errors.full_messages.join(", ")
    end
    redirect_to user_winning_history_index_path
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def validate_user_profile
    raise ActionController::RoutingError.new('Not Found') unless @user == current_user
  end

  def user_address_params
    params.require(:winner).permit(:user_address_id)
  end
end
