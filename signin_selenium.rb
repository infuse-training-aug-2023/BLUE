
require 'selenium-webdriver'

Selenium::WebDriver::Chrome::Service.driver_path = 'C:\Users\madhura.patil\Desktop\Git training\selenium\drivers\chromedriver.exe'
driver = Selenium::WebDriver.for :chrome

begin
  driver.get 'https://neemans.com/account/login?return_url=%2Faccount'

#   login_link = driver.find_element(:xpath, '//*[@id="full-new-announcement"]/div[2]/ul/li[1]/a')
  email = driver.find_element(:name, 'customer[email]')
  password = driver.find_element(:name, 'customer[password]')
  login_button = driver.find_element(:css, 'button[type="submit"]')

#   login_link.click

  email.send_keys("madhura.patil54@gmail.com")
  password.send_keys("abcdef24")
  login_button.click

  sleep 10
rescue StandardError => e
  puts "An error occurred: #{e.message}"
ensure
  driver.quit
end
