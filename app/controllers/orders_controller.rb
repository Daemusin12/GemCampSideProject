class OrdersController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @orders = Order.all
    @orders = @orders.filter_by_serial(params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.filter_by_email(params[:email]) if params[:email].present?
    @orders = @orders.filter_by_genre(params[:genre]) if params[:genre].present?
    @orders = @orders.filter_by_state(params[:state]) if params[:state].present?
    @orders = @orders.filter_by_offer(params[:offer]) if params[:offer].present?
    @orders = @orders.filter_by_start_date(params[:start_date]) if params[:start_date].present?
    @orders = @orders.filter_by_end_date(params[:end_date]) if params[:end_date].present?
    @total_amount = @orders.sum(:amount)
    @total_coins = @orders.sum(:coins)
  end

  def pay
    @order = Order.find(params[:order_id])
    if @order.may_pay?
      @order.pay!
      flash[:notice] = 'Paid!'
    else
      flash[:notice] = "Can't pay!"
    end
    redirect_to orders_path
  end

  def cancel
    @order = Order.find(params[:order_id])
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = 'Cancelled!'
    else
      flash[:notice] = "Can't cancel!"
    end
    redirect_to orders_path
  end

end
