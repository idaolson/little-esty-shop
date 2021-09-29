require "rails_helper"

RSpec.describe "Admin Invoices Show Page" do
  describe "group project" do
    before :each do
      allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
      allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
      allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})
      @joey = Customer.create!(first_name: "Joey", last_name: "Ondricka", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC")
      @cecelia = Customer.create!(first_name: "Cecelia", last_name: "Osinski", created_at: "2012-03-27 14:54:10 UTC", updated_at: "2012-03-27 14:54:10 UTC")
      @mariah = Customer.create!(first_name: "Mariah", last_name: "Toy", created_at: "2012-03-27 14:54:10 UTC", updated_at: "2012-03-27 14:54:10 UTC")

      @invoice_1 = @joey.invoices.create!(customer_id: 1, status: "completed", created_at: "2012-03-13 16:54:10 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @invoice_2 = @cecelia.invoices.create!(customer_id: 2, status: "cancelled", created_at: "2012-03-07 12:54:10 UTC", updated_at: "2012-03-13 16:54:10 UTC")
      @invoice_3 = @mariah.invoices.create!(customer_id: 3, status: "in progress", created_at: "2012-03-06 21:54:10 UTC", updated_at: "2012-03-06 21:54:10 UTC")

      @zara = Merchant.create!(name: "Zara")
      @forever_21 = Merchant.create!(name: "Forever 21")

      @hat = @zara.items.create!(name: "Hat", description: "Sun hat", unit_price: 1200, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @socks = @zara.items.create!(name: "Socks", description: "Heart pattern socks", unit_price: 600, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @tank_top = @zara.items.create!(name: "Tank top", description: "Work out tank top", unit_price: 1800, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @shorts = @forever_21.items.create!(name: "Shorts", description: "Black denim shorts", unit_price: 4000, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @dress = @forever_21.items.create!(name: "Dress", description: "Sun dress", unit_price: 2900, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @skirt = @forever_21.items.create!(name: "Skirt", description: "Polka dot skirt", unit_price: 2500, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")

      @invoice_item_1 = InvoiceItem.create!(item: @hat, invoice: @invoice_1, quantity: 2, unit_price: 1200, status: "pending", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_2 = InvoiceItem.create!(item: @socks, invoice: @invoice_1 , quantity: 2, unit_price: 600, status: "pending", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_3 = InvoiceItem.create!(item: @tank_top , invoice: @invoice_2, quantity: 1 , unit_price: 1800, status: "shipped", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_4 = InvoiceItem.create!(item: @shorts, invoice: @invoice_3  , quantity: 1 , unit_price: 4000, status: "shipped", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_5 = InvoiceItem.create!(item: @dress, invoice: @invoice_3, quantity: 5, unit_price: 2900, status: "packaged", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_6 = InvoiceItem.create!(item: @skirt, invoice: @invoice_3, quantity: 3, unit_price: 2500, status: "packaged", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
    end

    describe "Invoice Info" do
      it "display that invoice's information" do
        visit "/admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@invoice_1.updated_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@invoice_1.customer.first_name)
        expect(page).to have_content(@invoice_1.customer.last_name)
      end
    end

    describe "Items on Invoice" do
      it "displays the items' info on that invoice" do
        visit "/admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content(@hat.name)
        expect(page).to have_content(@invoice_item_1.quantity)
        expect(page).to have_content(@invoice_item_1.item.unit_price_dollars)
        expect(page).to have_content(@invoice_item_1.status)

        expect(page).to have_content(@socks.name)
        expect(page).to have_content(@invoice_item_2.quantity)
        expect(page).to have_content(@invoice_item_2.item.unit_price_dollars)
        expect(page).to have_content(@invoice_item_2.status)
      end

      it "displays the items' info on that invoice" do
        visit "/admin/invoices/#{@invoice_2.id}"

        expect(page).to have_content(@tank_top.name)
        expect(page).to have_content(@invoice_item_3.quantity)
        expect(page).to have_content(@invoice_item_3.item.unit_price_dollars)
        expect(page).to have_content(@invoice_item_3.status)
      end

      it "displays the items' info on that invoice" do
        visit "/admin/invoices/#{@invoice_3.id}"

        expect(page).to have_content(@shorts.name)
        expect(page).to have_content(@invoice_item_4.quantity)
        expect(page).to have_content(@invoice_item_4.item.unit_price_dollars)
        expect(page).to have_content(@invoice_item_4.status)

        expect(page).to have_content(@dress.name)
        expect(page).to have_content(@invoice_item_5.quantity)
        expect(page).to have_content(@invoice_item_5.item.unit_price_dollars)
        expect(page).to have_content(@invoice_item_5.status)

        expect(page).to have_content(@skirt.name)
        expect(page).to have_content(@invoice_item_6.quantity)
        expect(page).to have_content(@invoice_item_6.item.unit_price_dollars)
        expect(page).to have_content(@invoice_item_6.status)
      end
    end

    describe "Total Revenue" do
      it "can generate the talal revenue from that invoice" do
        visit "/admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content("Total Revenue:")
        expect(page).to have_content(@invoice_1.total_revenue)
      end

      it "can generate the talal revenue from that invoice" do
        visit "/admin/invoices/#{@invoice_2.id}"

        expect(page).to have_content("Total Revenue:")
        expect(page).to have_content(@invoice_2.total_revenue)
      end

      it "can generate the talal revenue from that invoice" do
        visit "/admin/invoices/#{@invoice_3.id}"

        expect(page).to have_content("Total Revenue:")
        expect(page).to have_content(@invoice_3.total_revenue)
        expect(page).to have_no_content(@invoice_2.total_revenue)
      end
    end

    describe "Update Invoice Status" do
      it "displays a select field for invoice status" do
        visit "/admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_select(selected: "completed")
      end

      it "allows admin to select a new status and update it" do
        visit "/admin/invoices/#{@invoice_1.id}"

        select "cancelled"
        click_on "Update Invoice Status"

        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content("cancelled")
        expect(page).to have_select(selected: "cancelled")

        expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      end
    end
  end

  describe "bulk discounts tests" do
    before :each do
      allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
      allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
      allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})

      @mariah = Customer.create!(first_name: "Mariah", last_name: "Toy", created_at: "2012-03-27 14:54:10 UTC", updated_at: "2012-03-27 14:54:10 UTC")

      @invoice_1 = @mariah.invoices.create!(customer_id: 3, status: "in progress", created_at: "2012-03-06 21:54:10 UTC", updated_at: "2012-03-06 21:54:10 UTC")

      @zara = Merchant.create!(name: "Zara")
      @forever_21 = Merchant.create!(name: "Forever 21")

      @hat = @zara.items.create!(name: "Hat", description: "Sun hat", unit_price: 1231, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @socks = @zara.items.create!(name: "Socks", description: "Heart pattern socks", unit_price: 2351, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @tank_top = @zara.items.create!(name: "Tank top", description: "Work out tank top", unit_price: 2913, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @shorts = @forever_21.items.create!(name: "Shorts", description: "Black denim shorts", unit_price: 7219, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @dress = @forever_21.items.create!(name: "Dress", description: "Sun dress", unit_price: 2938, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @skirt = @forever_21.items.create!(name: "Skirt", description: "Polka dot skirt", unit_price: 2500, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")

      @invoice_item_1 = InvoiceItem.create!(item: @hat, invoice: @invoice_1, quantity: 5, unit_price: 1231, status: "pending", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_2 = InvoiceItem.create!(item: @socks, invoice: @invoice_1 , quantity: 2, unit_price: 2351, status: "pending", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_3 = InvoiceItem.create!(item: @tank_top , invoice: @invoice_1, quantity: 12 , unit_price: 2913, status: "shipped", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_4 = InvoiceItem.create!(item: @shorts, invoice: @invoice_1  , quantity: 15, unit_price: 7219, status: "shipped", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_5 = InvoiceItem.create!(item: @dress, invoice: @invoice_1, quantity: 20, unit_price: 2938, status: "packaged", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
      @invoice_item_6 = InvoiceItem.create!(item: @skirt, invoice: @invoice_1, quantity: 50, unit_price: 2500, status: "packaged", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")

      @bd1 = @zara.bulk_discounts.create!(name: "Spooky Showdown", discount: 0.20, threshold: 5)
      @bd2 = @zara.bulk_discounts.create!(name: "Memorial Day Bonanza", discount: 0.30, threshold: 15)
      @bd3 = @zara.bulk_discounts.create!(name: "Wacky Wednesday", discount: 0.10, threshold: 20)
      @bd4 = @zara.bulk_discounts.create!(name: "Oops, We Discounted Again!", discount: 0.50, threshold: 50)
      @bd5 = @forever_21.bulk_discounts.create!(name: "Christmas Clearance", discount: 0.20, threshold: 5)
      @bd6 = @forever_21.bulk_discounts.create!(name: "Please, Sir, Buy Some More", discount: 0.30, threshold: 15)
      @bd7 = @forever_21.bulk_discounts.create!(name: "Pandemic Pandemonium", discount: 0.10, threshold: 20)
      @bd8 = @forever_21.bulk_discounts.create!(name: "Help Me My Family Is Dying", discount: 0.50, threshold: 50)
    end

    it "shows the total revenue from this invoice" do
      visit admin_invoice_path(@invoice_1)

      expect(@invoice_1.total_revenue.round(2)).to eq(3378.58)
      expect(page).to have_content("Total Revenue: $3,378.58")
    end

    it "shows the total discounted revenue from this invoice" do
      visit admin_invoice_path(@invoice_1)

      expect(@invoice_1.total_discount_revenue.round(2)).to eq(2170.22)
      expect(page).to have_content("Discounted Revenue: $2,170.22")
    end
  end
end
