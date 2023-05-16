class WinnerController < ApplicationController
  def index
    @winners = Winner.all
    @winners = @winners.filter_by_serial(params[:serial_number]) if params[:serial_number].present?
    @winners = @winners.filter_by_email(params[:email]) if params[:email].present?
    @winners = @winners.filter_by_state(params[:state]) if params[:state].present?
    @winners = @winners.filter_by_start_date(params[:start_date]) if params[:start_date].present?
    @winners = @winners.filter_by_end_date(params[:end_date]) if params[:end_date].present?
  end

  def claim
    @winner = Winner.find(params[:winner_id])
    if @winner.may_claim?
      @winner.claim!
      flash[:notice] = 'Claimed!'
    else
      flash[:notice] = "Can't claim!"
    end
    redirect_to winner_path
  end

  def submit
    @winner = Winner.find(params[:winner_id])
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = 'Submitted!'
    else
      flash[:notice] = "Can't submit!"
    end
    redirect_to winner_path
  end

  def pay
    @winner = Winner.find(params[:winner_id])
    if @winner.may_pay?
      @winner.pay!
      flash[:notice] = 'Paid!'
    else
      flash[:notice] = "Can't pay!"
    end
    redirect_to winner_path
  end

  def ship
    @winner = Winner.find(params[:winner_id])
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = 'Shipped!'
    else
      flash[:notice] = "Can't ship!"
    end
    redirect_to winner_path
  end

  def deliver
    @winner = Winner.find(params[:winner_id])
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = 'Delivered!'
    else
      flash[:notice] = "Can't deliver!"
    end
    redirect_to winner_path
  end

  def share
    @winner = Winner.find(params[:winner_id])
    if @winner.may_share?
      @winner.share!
      flash[:notice] = 'Shared!'
    else
      flash[:notice] = "Can't share!"
    end
    redirect_to winner_path
  end

  def publish
    @winner = Winner.find(params[:winner_id])
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = 'Published!'
    else
      flash[:notice] = "Can't publish!"
    end
    redirect_to winner_path
  end

  def remove_publish
    @winner = Winner.find(params[:winner_id])
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = 'Remove_published!'
    else
      flash[:notice] = "Can't remove publish!"
    end
    redirect_to winner_path
  end

end
