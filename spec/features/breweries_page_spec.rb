require 'rails_helper'

describe 'Breweries page' do
  it 'should not have any before been created' do
    visit breweries_path
    expect(page).to have_content 'Number of retired breweries: 0'
    expect(page).to have_content 'Number of active breweries: 0'
  end

  describe 'when breweries exists' do

    before :each do
      @breweries = ['Koff', 'Karjala', 'Schlenkerla']
      year = 1896
      @breweries.each do |brewery_name|
        FactoryGirl.create(:brewery, name:brewery_name, year:year += 1)
      end

      visit breweries_path
    end

    it 'lists the existing breweries and their total number' do
      expect(page).to have_content "Number of active breweries: #{@breweries.count}"

      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it 'lists retired breweries and their total number' do
      retired = ['Test', 'Test2']
      retired.each do |brewery|
        FactoryGirl.create(:brewery, name:brewery, active:false)
      end

      visit breweries_path

      expect(page).to have_content "Number of retired breweries: #{retired.count}"

      retired.each do |brewery|
        expect(page).to have_content brewery
      end
    end

    it 'allows user to navigate to page of a Brewery' do
      click_link 'Koff'

      expect(page).to have_content 'Koff'
      expect(page).to have_content 'Established in 1897'
    end

  end
end