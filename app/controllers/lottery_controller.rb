class LotteryController < ApplicationController

  def index
    @items = Item.includes(:categories).all
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end
end
