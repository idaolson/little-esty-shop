require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:discount) }
    it { should validate_presence_of(:threshold) }
  end

  before :each do
    @merchant = Merchant.create!(name:"Spirit Halloween")
    @bd1 = @merchant.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
    @bd2 = @merchant.bulk_discounts.create!(name: "Memorial Day Bonanza", discount: 0.30, threshold: 15)
    @bd3 = @merchant.bulk_discounts.create!(name: "Wacky Wednesday", discount: 0.10, threshold: 20)
    @bd4 = @merchant.bulk_discounts.create!(name: "Oops, we discounted again!", discount: 0.50, threshold: 50)
  end

  it "multiplies by 100 to return percentage" do
    expect(@bd1.percentage.to_i).to eq(20)
    expect(@bd2.percentage.to_i).to eq(30)
    expect(@bd3.percentage.to_i).to eq(10)
    expect(@bd4.percentage.to_i).to eq(50)
  end

  it "subtracts discount percentage from one hundred to get decimal remaining after discount" do
    expect(@bd1.deduct_discount).to eq(0.8)
  end
end
