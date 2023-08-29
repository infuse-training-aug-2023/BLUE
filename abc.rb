require 'test/unit'
require_relative 'main'  # Make sure to adjust the path to the main file

class WebsiteTest < Test::Unit::TestCase

  def setup
    @neemans_testing = NeemansTesting.new('C:\Users\madhura.patil\Desktop\Git training\selenium\drivers\chromedriver.exe')
  end

  def teardown
    @neemans_testing.quit
  end

  def test_signup
    test_cases = [
      { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'StrongPass123*' },
      { first_name: '123', last_name: '456', email: 'invalid-email', password: 'weakpassword' }
      # Add more test cases here
    ]
    
    test_cases.each do |test_case|
      assert_match(/^[a-zA-Z]+$/, test_case[:first_name])
      puts "#{test_case[:first_name]} is #{test_case[:first_name].match(/^[a-zA-Z]+$/) ? 'Valid' : 'Invalid'}"
      
      assert_match(/^[a-zA-Z]+$/, test_case[:last_name])
      puts "#{test_case[:last_name]} is #{test_case[:last_name].match(/^[a-zA-Z]+$/) ? 'Valid' : 'Invalid'}"
      
      assert_match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, test_case[:email])
      puts "#{test_case[:email]} is #{test_case[:email].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i) ? 'Valid' : 'Invalid'}"
      
      assert_match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/, test_case[:password])
      puts "#{test_case[:password]} is #{test_case[:password].match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/) ? 'Valid' : 'Invalid'}"
    end
  end

  def test_login
    test_cases = [
      { email: 'john.doe@example.com', password: 'StrongPass123*' }
      # Add more test cases here
    ]
    
    test_cases.each do |test_case|
      assert_match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, test_case[:email])
      puts "#{test_case[:email]} is #{test_case[:email].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i) ? 'Valid' : 'Invalid'}"
      
      assert_match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/, test_case[:password])
      puts "#{test_case[:password]} is #{test_case[:password].match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/) ? 'Valid' : 'Invalid'}"
      
      # Add assertions here to check if the login was successful
    end
  end

end
