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
  end

  private

  def bd_params
     params.require(:bulk_discount).permit(:name, :discount, :threshold, :merchant_id)
  end
end
