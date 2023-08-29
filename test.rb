# test.rb

require 'rspec'
require_relative 'main'

RSpec.describe 'Website functionalities' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
  end

  after(:all) do
    @driver.quit
  end

  it 'should allow user to signup' do
    # Test signup functionality
  end

  it 'should allow user to login' do
    # Test login functionality
  end

  it 'should allow user to search' do
    # Test search functionality
  end

  it 'should allow user to sort' do
    # Test sort functionality
  end

  it 'should allow user to add item to cart' do
    # Test add to cart functionality
  end

  it 'should allow user to remove item from cart' do
    # Test remove from cart functionality
  end
end