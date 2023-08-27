require 'selenium-webdriver'

Selenium::WebDriver::Chrome::Service.driver_path='G:/selenium training/drivers/chromedriver.exe'
driver=Selenium::WebDriver.for :chrome


driver.get 'https://neemans.com/products/comfort-wave-sneakers?variant=40841954197547'


driver.manage.window.maximize


# driver.find_element(:css,'#product_form_7131903066155 > div.ProductForm__Variants > div:nth-child(1) > ul > li.HorizontalList__Item.last-tw.liColorSwatch > label > img').click
wait = Selenium::WebDriver::Wait.new(timeout: 15)
element = wait.until { driver.find_element(:css, '#product_form_7131903066155 > div.ProductForm__Variants > div:nth-child(1) > ul > li.HorizontalList__Item.last-tw.liColorSwatch > label > img') }

label_element = driver.find_element(:css, '#product_form_7131903066155 > div.ProductForm__Variants > div:nth-child(2) > ul > li:nth-child(1) > label')
label_element.click

button=driver.find_element(:css,'#product_form_7131903066155 > div.ProductForm__AddToCart_container > button')
button.click

add=driver.find_element(:id,'sidebar-cart')

add1=wait.until{add.find_element(:css,'#sidebar-cart > form > div.Drawer__Main > div.Drawer__Container > div > div > div > div.CartItem__Info > div.CartItem__Actions.Heading.Text--subdued > div > div > a.QuantitySelector__Button.Link.Link--primary.p')}
add1.click

price_element= driver.find_element(:css,'#sidebar-cart > form > div.Drawer__Main > div.Drawer__Container > div > div > div > div.CartItem__Info > div.CartItem__Meta.Heading.Text--subdued > div > span:nth-child(1)')
price_text = price_element.text
puts price_element.text

# puts "Price: #{price_text}"

# sub1=wait.until{driver.find_element(:css,'#sidebar-cart > form > div.Drawer__Main > div.Drawer__Container > div > div > div > div.CartItem__Info > div.CartItem__Actions.Heading.Text--subdued > div > div > a.QuantitySelector__Button.Link.Link--primary.m')}
# sub1.click
# sub1.click




sleep(5)









