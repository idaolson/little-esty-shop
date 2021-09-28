
require 'rails_helper'

RSpec.describe "bulk discounts new page" do
  before :each do
    @merchant = Merchant.create!(name:"Spirit Halloween")
  end

  it "has a form to create new discounts" do
    visit new_merchant_bulk_discount_path(@merchant)

    fill_in "Name", with: "Super Smash Sale"
    fill_in "Discount", with: 0.25
    fill_in "Minimum Quantity", with: 10
    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content("New discount created!")

    bd = BulkDiscount.last

    within "#discount-#{bd.id}" do
      expect(page).to have_content("Super Smash Sale")
      expect(page).to have_content("25%")
      expect(page).to have_content(10)
    end
  end

  it "new discount sad path" do
    visit new_merchant_bulk_discount_path(@merchant)

    fill_in "Name", with: "Super Smash Sale"
    fill_in "Discount", with: 0.25
    click_button "Submit"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    expect(page).to have_content("Discount not created. Try again.")
  end
end

# Merchant Bulk Discount Create
#
# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed
