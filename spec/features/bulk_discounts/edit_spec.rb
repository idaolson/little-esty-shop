require 'rails_helper'

RSpec.describe "bulk discounts edit page" do
  before :each do
    @merchant = Merchant.create!(name:"Spirit Halloween")
    @bd1 = @merchant.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
  end

  it "links to edit from the bulk discount show page" do
    visit edit_merchant_bulk_discount_path(@merchant, @bd1)

    expect(page).to have_field("Name", with: "Spooky Showdown")
    expect(page).to have_field("Discount", with: "0.2")
    expect(page).to have_field("Minimum Quantity", with: "5")

    fill_in "Name", with: "Super Smash Sale"
    fill_in "Discount", with: 0.25
    fill_in "Minimum Quantity", with: 10
    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bd1))
    expect(page).to have_content("Bulk Discount Updated!")
    expect(page).to have_content("Super Smash Sale")
    expect(page).to have_content("25%")
    expect(page).to have_content(10)
  end

  it "links to edit from the bulk discount show page" do
    visit edit_merchant_bulk_discount_path(@merchant, @bd1)

    fill_in "Name", with: "Super Smash Sale"
    fill_in "Discount", with: 0.25
    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bd1))
    expect(page).to have_content("Bulk Discount Updated!")
    expect(page).to have_content("Super Smash Sale")
    expect(page).to have_content("25%")
    expect(page).to have_content(5)
  end
end
