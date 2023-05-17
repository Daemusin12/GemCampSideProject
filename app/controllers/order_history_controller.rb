class OrderHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @user = current_user
    @orders = Order.where(user: @user)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def cancel
    @order = Order.find(params[:order_history_id])
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = 'Cancelled!'
    else
      flash[:notice] = "Can't cancel!"
    end
      redirect_to user_order_history_index_path
  end

end
