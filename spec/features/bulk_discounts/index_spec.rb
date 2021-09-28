require 'rails_helper'

RSpec.describe "bulk discounts index" do
  before :each do
    @merchant = Merchant.create!(name:"Spirit Halloween")
    @bd1 = @merchant.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
    @bd2 = @merchant.bulk_discounts.create!(name: "Memorial Day Bonanza", discount: 0.30, threshold: 15)
    @bd3 = @merchant.bulk_discounts.create!(name: "Wacky Wednesday", discount: 0.10, threshold: 20)
    @bd4 = @merchant.bulk_discounts.create!(name: "Oops, We Discounted Again!", discount: 0.50, threshold: 50)
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

  it "displays three upcoming holidays" do
    visit merchant_bulk_discounts_path(@merchant)

    expect(page).to have_content("Columbus Day")
    expect(page).to have_content("2021-10-11")

    expect(page).to have_content("Veterans Day")
    expect(page).to have_content("2021-11-11")

    expect(page).to have_content("Thanksgiving Day")
    expect(page).to have_content("2021-11-25")
  end

  it "has a link to create a new bulk discount" do
    visit merchant_bulk_discounts_path(@merchant)

    click_button "Create New Discount"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end

  it "has a link to delete next to each bulk discount" do
    visit merchant_bulk_discounts_path(@merchant)

    within "#discount-#{@bd1.id}" do
      expect(page).to have_content(@bd1.name)
      click_button "Delete"
    end
    expect(page).to have_no_content(@bd1.name)
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
  end
end
#
# Merchant Bulk Discount Delete
#
# As a merchant
# When I visit my bulk discounts index
# Then next to each bulk discount I see a link to delete it
# When I click this link
# Then I am redirected back to the bulk discounts index page
# And I no longer see the discount listed
