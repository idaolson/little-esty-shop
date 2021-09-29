require 'rails_helper'

RSpec.describe 'Merchant invoices show page' do
  describe "group project" do
    before :each do
      allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
      allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
      allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})
      @merch = create(:merchant)
      @merch2 = create(:merchant)
      @item1 = create(:item, merchant_id: @merch.id)
      @item2 = create(:item, merchant_id: @merch.id)
      @item3 = create(:item, merchant_id: @merch2.id)
      @cust = create(:customer)
      @invoice1 = create(:invoice, customer_id: @cust.id)
      @inv_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, unit_price: @item1.unit_price)
      @inv_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, unit_price: @item2.unit_price)
      @inv_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id, unit_price: @item3.unit_price)
    end

    it "shows invoice attribues" do
      visit "/merchant/#{@merch.id}/invoices/#{@invoice1.id}"

      within('#attributes') do
        expect(page).to have_content("Invoice ##{@invoice1.id}")
        expect(page).to have_content("Status: #{@invoice1.status}")
        expect(page).to have_content("Created on: Tuesday, March 27, 2012")
        expect(page).to have_content("Customer: #{@cust.first_name} #{@cust.last_name}")
      end
    end

    it "shows invoice item" do
      visit "/merchant/#{@merch.id}/invoices/#{@invoice1.id}"

      sum1 = @inv_item1.price_dollars(@inv_item1.quantity)
      within('#items') do
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@inv_item1.quantity)
        expect(page).to have_content("$#{sum1}")
        expect(page).to have_content(@inv_item1.status)

        expect(page).to have_content(@item2.name)
        expect(page).to_not have_content(@item3.name)
      end
    end

     it "shows a drop down selector to change the status" do
       visit merchant_invoice_path(@merch.id, @invoice1.id)

       within("#invoice-item#{@inv_item1.id}") do
         select(:packaged)
         click_button "Update Status"
       end

       expect(page).to have_content("Item Updated Successfully")
       expect(current_path).to eq(merchant_invoice_path(@merch.id, @invoice1.id))

       within("#invoice-item#{@inv_item1.id}") do
         expect(page).to have_content('packaged')
       end
     end
  end
  describe "bulk discounts project" do

    before :each do
      allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
      allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
      allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})
      @merch1 = Merchant.create!(name: "Spirit Halloween")
      @item1 = @merch1.items.create!(name: "Polly Pocket", description: "So pretty", unit_price: 862, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @item2 = @merch1.items.create!(name: "Cabbage Patch Doll", description: "Cute", unit_price: 1239, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @item3 = @merch1.items.create!(name: "Teddy Ruxpin", description: "Creepy", unit_price: 1543, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @item4 = @merch1.items.create!(name: "Barbie", description: "Gorgeous", unit_price: 2183, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @cust = create(:customer)
      @invoice = create(:invoice, customer_id: @cust.id)
      @ii1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice.id, quantity: 4, unit_price: 2335, status: :shipped, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @ii2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice.id, quantity: 8, unit_price: 1235, status: :shipped, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @ii3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice.id, quantity: 26, unit_price: 2342, status: :shipped, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @ii4 = InvoiceItem.create!(item_id: @item4.id, invoice_id: @invoice.id, quantity: 51, unit_price: 1231, status: :shipped, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @bd1 = @merch1.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
      @bd2 = @merch1.bulk_discounts.create!(name: "Memorial Day Bonanza", discount: 0.30, threshold: 15)
      @bd3 = @merch1.bulk_discounts.create!(name: "Wacky Wednesday", discount: 0.10, threshold: 20)
      @bd4 = @merch1.bulk_discounts.create!(name: "Oops, We Discounted Again!", discount: 0.50, threshold: 50)
    end



    it "shows total invoice revenue without disounts and total discounted revenue incl. bulk discounts" do
      visit merchant_invoice_path(@merch1.id, @invoice.id)

      expect(page).to have_content("Total Revenue: $1,428.93")
      expect(page).to have_content("Discounted Revenue: $912.59")
    end
  end
end

# Total Revenue /discounted revenue
#
# As a merchant
# When I visit my merchant invoice show page
# Then I see the total revenue for my merchant from
# this invoice (not including discounts)
# And I see the total discounted revenue for my merchant
# from this invoice which includes bulk discounts in the
# calculation
