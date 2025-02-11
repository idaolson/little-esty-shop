require 'rails_helper'

describe 'Admin Merchants Show' do
  before :each do
    allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
    allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
    allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})
    @merchant1 = Merchant.create!(name: 'Jason Momoa', created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
    @merchant2 = Merchant.create!(name: 'The Rock', created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
  end

  it 'links to AdminMerchant Show page w/Merchant name' do
    visit admin_merchants_path

    click_link 'Jason Momoa'

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
    expect(page).to have_content('Jason Momoa')
  end
end
