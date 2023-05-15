class LotteriesController < ApplicationController

  def index
    @items = Item.includes(:categories).active.starting
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end

  def show
    @item = Item.find(params[:id])
    @bet = Bet.new
    @bets = Bet.where(user: current_user, item: @item, batch_count: @item.batch_count)
  end

  def create
    @bets_qty = params[:bet][:coins].to_i
    @bets_qty.times do
      @bet = Bet.new
      @bet.user = current_user
      @item = Item.starting.find(params[:bet][:item_id])
      @bet.item = @item
      @bet.batch_count = @item.batch_count
      if @bet.save
        flash[:notice] = 'Bet Successfully.'
      else
        flash[:notice] = 'Bet Failed.'
      end
    end
    redirect_to lotteries_path
  end

end
