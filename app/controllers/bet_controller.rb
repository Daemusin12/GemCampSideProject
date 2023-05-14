class BetController < ApplicationController
  def index
    @bets = Bet.all
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
