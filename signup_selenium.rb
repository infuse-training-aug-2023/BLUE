
require 'selenium-webdriver'

Selenium::WebDriver::Chrome::Service.driver_path = 'C:\Users\madhura.patil\Desktop\Git training\selenium\drivers\chromedriver.exe'
driver = Selenium::WebDriver.for :chrome

begin

  
  driver.get 'https://neemans.com/account/register'

  
#   signup = driver.find_element(:link_text, 'Create one')

  first_name = driver.find_element(:css, 'input.Form__Input[name="customer[first_name]"]')
  last_name= driver.find_element(:css, 'input.Form__Input[name="customer[last_name]"]')
  email = driver.find_element(:css, 'input.Form__Input[name="customer[email]"]')
  password = driver.find_element(:name, 'customer[password]')
  signup_button = driver.find_element(:css, 'button[type="submit"]')


  
#   login_button = driver.find_element(:css, 'button[type="submit"]')

#   login_link.click
#   signup.click

  first_name.send_keys("Jack")
  last_name.send_keys("Sparrow")
  email.send_keys("jacksparrow@gmail.com")
  password.send_keys("abcdefgh24")

  signup_button.click
  
#   password.send_keys("abcdef24")
#   login_button.click

  sleep 10
rescue StandardError => e
  puts "An error occurred: #{e.message}"
ensure
  driver.quit
end
