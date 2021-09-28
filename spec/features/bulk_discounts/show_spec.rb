
require 'rails_helper'

RSpec.describe "bulk discounts show page" do
  before :each do
    @merchant = Merchant.create!(name:"Spirit Halloween")
    @bd1 = @merchant.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
  end

  it "displays the bulk discount's quantity threshold and percentage discount" do
    visit merchant_bulk_discount_path(@merchant, @bd1)

    expect(page).to have_content(@merchant.name)
    expect(page).to have_content(@bd1.name)
    expect(page).to have_content(@bd1.threshold)
    expect(page).to have_content("#{@bd1.percentage.to_i}%")
  end

  it "links to edit from the bulk discount show page" do
    visit merchant_bulk_discount_path(@merchant, @bd1)

    click_link "Edit Discount"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bd1))
  end
end
