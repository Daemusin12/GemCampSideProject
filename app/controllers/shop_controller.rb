class ShopController < ApplicationController
  before_action :authenticate_user!, only: [:buy]

  def index
    @offers = Offer.active.all
  end

  def buy
    @offer = Offer.find(params[:shop_id])
    @order = Order.new
    @order.user = current_user
    @order.offer = @offer
    @order.amount = @offer.amount
    @order.coins = @offer.coins
    if @order.save
      flash[:notice] = 'Order Successfully.'
    else
      flash[:notice] = 'Order Failed.'
    end
    redirect_to shop_index_path
  end

end
