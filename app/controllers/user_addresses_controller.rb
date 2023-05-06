class UserAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]
  before_action :set_user
  before_action :validate_user_profile
  def index
    @addresses = UserAddress.where(user_id: @user.id)
  end

  def new
    @address = UserAddress.new
  end

  def create
    @address = UserAddress.new(address_params)
    @address.user_id = @user.id
    if @address.save
      redirect_to user_user_addresses_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end
  def update
    if @address.update(address_params)
      redirect_to user_user_addresses_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to user_user_addresses_path
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_address
    @address = UserAddress.find(params[:id])
  end

  def address_params
    params.require(:user_address).permit(:name, :genre, :street_address, :phone_number,
                                         :remark, :is_default, :address_region_id,
                                         :address_province_id, :address_city_id,
                                         :address_barangay_id)
  end

  def validate_user_profile
    raise ActionController::RoutingError.new('Not Found') unless @user == current_user
  end

end

