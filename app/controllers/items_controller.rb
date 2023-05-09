class ItemsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]


  def index
    @items = Item.includes(:categories).all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to items_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = "item is deleted successfully"
    else
      flash[:alert] = @item.errors.full_messages.join(", ")
    end
    redirect_to items_path
  end

  def start
    @item = Item.find(params[:item_id])
    if @item.may_start?
      @item.start!
      flash[:notice] = 'Started!'
    else
      flash[:notice] = "Can't start!"
    end
    redirect_to items_path
  end

  def pause
    @item = Item.find(params[:item_id])
    if @item.may_pause?
      @item.pause!
      flash[:notice] = 'Paused!'
    else
      flash[:notice] = "Can't pause!"
    end
    redirect_to items_path
  end

  def end
    @item = Item.find(params[:item_id])
    if @item.may_end?
      @item.end!
      flash[:notice] = 'Ended!'
    else
      flash[:notice] = "Can't end!"
    end
    redirect_to items_path
  end

  def cancel
    @item = Item.find(params[:item_id])
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = 'Canceled!'
    else
      flash[:notice] = "Can't cancel!"
    end
    redirect_to items_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :image, :quantity, :minimum_bets, :batch_count,
                                 :online_at, :offline_at, :start_at, category_ids: [])
  end

end
