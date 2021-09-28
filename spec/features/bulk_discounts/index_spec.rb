require 'rails_helper'

RSpec.describe "bulk discounts index" do
  before :each do
    @merchant = Merchant.create!(name:"Spirit Halloween")
    @bd1 = @merchant.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
    @bd2 = @merchant.bulk_discounts.create!(name: "Memorial Day Bonanza", discount: 0.30, threshold: 15)
    @bd3 = @merchant.bulk_discounts.create!(name: "Wacky Wednesday", discount: 0.10, threshold: 20)
    @bd4 = @merchant.bulk_discounts.create!(name: "Oops, we discounted again!", discount: 0.50, threshold: 50)
  end

  it "links from merchant dashboard to bulk discounts index" do
    visit merchant_dashboard_index_path(@merchant)

    expect(page).to have_link("My Discounts")
    click_link "My Discounts"
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
  end

  it "displays all bulk discounts including discount, threshold and link to bulk discount show page" do
    visit merchant_bulk_discounts_path(@merchant)

    @merchant.bulk_discounts.each do |discount|
      within "#discount-#{discount.id}" do
        expect(page).to have_link(discount.name, href: merchant_bulk_discount_path(@merchant, discount))
        expect(page).to have_content("#{discount.percentage.to_i}%")
        expect(page).to have_content(discount.threshold)
      end
    end
  end
end
