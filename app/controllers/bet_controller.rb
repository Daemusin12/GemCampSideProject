class BetController < ApplicationController
  before_action :authenticate_admin_user!
  def index
    @bets = Bet.all
    @bets = @bets.filter_by_item(params[:item_name]) if params[:item_name].present?
    @bets = @bets.filter_by_email(params[:email]) if params[:email].present?
    @bets = @bets.filter_by_state(params[:state]) if params[:state].present?
    @bets = @bets.filter_by_serial(params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.filter_by_start_date(params[:start_date]) if params[:start_date].present?
    @bets = @bets.filter_by_end_date(params[:end_date]) if params[:end_date].present?
  end

  def cancel
    @bet = Bet.find(params[:bet_id])
    if @bet.may_cancel?
      @bet.cancel!
      flash[:notice] = 'Canceled!'
    else
      flash[:notice] = "Can't cancel!"
    end
    redirect_to bet_path
  end

end
