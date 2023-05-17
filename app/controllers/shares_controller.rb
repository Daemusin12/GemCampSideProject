class SharesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @winner = Winner.where(user: current_user).find_by(params[:id])
  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])
    if @winner.update(user_share_params)
      @winner.share!
      flash[:notice] = "Share"
    else
      flash[:alert] = @winner.errors.full_messages.join(", ")
    end
    redirect_to user_winning_history_index_path
  end

  private

  def user_share_params
    params.require(:winner).permit(:picture, :comment)
  end

end
