class CouponsController < ApplicationController
  before_action :merchant_params
  def index
    @coupons = @merchant.coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
  end

  def create
    @coupon = @merchant.coupons.build(coupon_params)
    max_active_coupons = 5  
    if @merchant.active_coupons_count >= max_active_coupons
      flash[:alert] = "Merchant already has the maximum number of active coupons."
      render :new and return
    end
    
    if @coupon.save
      flash[:notice] = "Coupon created successfully."
      redirect_to merchant_coupons_path(@merchant)
    else
      flash[:alert] = "Failed to create coupon. Please ensure all fields are filled correctly."
      render :new
    end
  end

  def update
    coupon = Coupon.find(params[:id])
    if @merchant.invoices.completed
      @merchant.coupons.update!(coupon_params)
      flash[:alert] = "Status successfully updated"
    end

    if @merchant.invoices.in_progress
      flash[:alert] = "Coupon still in use"
    end
    redirect_to merchant_coupon_path(@merchant, coupon)
  end
    
  private
  
  def merchant_params
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def coupon_params
    params.permit(:name, :code, :discount_amount, :discount_type, :status, :merchant_id)
  end
end