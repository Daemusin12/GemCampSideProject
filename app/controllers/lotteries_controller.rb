class LotteriesController < ApplicationController

  def index
    @items = Item.includes(:categories).active.starting
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end
end
