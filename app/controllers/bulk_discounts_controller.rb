class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @bulk_discount = BulkDiscount.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @bulk_discount = BulkDiscount.new(bd_params)
    if @bulk_discount.save
      flash[:success] = 'New discount created!'
      redirect_to merchant_bulk_discounts_path
    else
      redirect_to new_merchant_bulk_discount_path
      flash[:danger] = 'Discount not created. Try again.'
    end
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def destroy
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount.update(bd_params)
    redirect_to merchant_bulk_discount_path
    flash[:success] = "Bulk Discount Updated!"
  end

  private

  def bd_params
     params.require(:bulk_discount).permit(:name, :discount, :threshold, :merchant_id)
  end
end
