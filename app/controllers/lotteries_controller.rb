class LotteriesController < ApplicationController

  def index
    @items = Item.includes(:categories).active.starting
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end

  def show
    @item = Item.find(params[:id])
    @bet = Bet.new
  end

  def create
    @bets_qty = params[:bet][:coins].to_i
    @bets_qty.times do
      @bet = Bet.new
      @item = Item.find(params[:bet][:item_id])
      @bet.user = current_user
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
