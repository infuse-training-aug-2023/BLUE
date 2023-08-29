require 'test/unit'
require_relative 'main'

class TestWebsiteFunctionalities < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :chrome
  end

  def teardown
    @driver.quit
  end

  def test_signup_functionality
    # Test signup functionality
  end

  def test_login_functionality
    # Test login functionality
  end

  def test_search_functionality
    # Test search functionality
  end

  def test_sort_functionality
    # Test sort functionality
  end

  def test_add_to_cart_functionality
    # Test add to cart functionality
  end

  def test_remove_from_cart_functionality
    # Test remove from cart functionality
  end
end



# require 'test/unit'

# class WebsiteTest < Test::Unit::TestCase

#   def setup
#     @driver_path = 'C:\Users\madhura.patil\Desktop\Git training\selenium\drivers\chromedriver.exe'
#     @timeout = 60
#     @neemans_testing = NeemansTesting.new(@driver_path, @timeout)
#   end

#   def test_signup
#     test_cases = [
#       { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'StrongPass123*' },
#       { first_name: '123', last_name: '456', email: 'invalid-email', password: 'weakpassword' }
#       # Add more test cases here
#     ]
    
#     test_cases.each do |test_case|
#       assert_match(/^[a-zA-Z]+$/, test_case[:first_name])
      
#       assert_match(/^[a-zA-Z]+$/, test_case[:last_name])
      
#       assert_match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, test_case[:email])
      
#       assert_match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/, test_case[:password])
#     end
#   end

#   def test_login
#     test_cases = [
#       { email: 'john.doe@example.com', password: 'StrongPass123*' }
#       # Add more test cases here
#     ]
    
#     test_cases.each do |test_case|
#       assert_match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, test_case[:email])
      
#       assert_match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/, test_case[:password])
      
#       # Add assertions here to check if the login was successful
#     end
#   end

#   def test_search
#     # Test search functionality
#   end

#   def test_sort
#     # Test sort functionality
#   end

#   def test_add_to_cart
#     # Test add to cart functionality
#   end

#   def test_remove_from_cart
#     # Test remove from cart functionality
#   end

# end
