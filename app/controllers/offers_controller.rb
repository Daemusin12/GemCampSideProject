class OffersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_offer, only: [:edit, :update, :destroy]

  def index
    @offers = Offer.all
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = 'Offer created successfully'
      redirect_to offers_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'Offer updated successfully'
      redirect_to offers_path
    else
      render :edit
    end
  end

  def destroy
    if @offer.destroy
      flash[:notice] = 'Offer destroyed successfully'
    else
      flash[:alert] = @offer.errors.full_messages.join(', ')
    end
    redirect_to offers_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :status, :amount, :coins)
  end
end
