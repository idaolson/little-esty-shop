require 'rails_helper'

describe 'Admin Merchants Update' do
  before :each do
    allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
    allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
    allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})
    @merchant1 = Merchant.create!(name: 'Steve Momoa', created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
    @merchant2 = Merchant.create!(name: 'The Rock', created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
  end

  it 'lists names of all Merchants' do
    visit "/admin/merchants/#{@merchant1.id}"

    click_link 'Update'

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}/edit")

    fill_in 'Name', with: "Jason Momoa"
    click_button 'Submit'

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
    expect(page).to have_content('Jason Momoa')
  end

  it 'returns flash message when not updated' do
    visit "/admin/merchants/#{@merchant1.id}"

    click_link 'Update'

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}/edit")

    fill_in 'Name', with: ''
    click_button 'Submit'

    expect(page).to have_content('Merchant Not Updated: Re-enter information')
  end
end
