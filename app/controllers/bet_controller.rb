class BetController < ApplicationController
  def index
    @bets = Bet.all
  end
end
