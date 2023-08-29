require 'selenium-webdriver'

class Driver
  def initialize(driver_path, browser, timeout)
    Selenium::WebDriver::Chrome::Service.driver_path = driver_path
    @driver = Selenium::WebDriver.for browser
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = timeout
  end

  def get(url)
    @driver.get(url)
  end

  def current_url
    @driver.current_url
  end

  def quit
    @driver.quit
  end
end

class MouseActions
  def initialize(driver)
    @driver = driver
  end

  def click(element)
    element.click
  end

  def move_to(element, x, y)
    if x.nil? || y.nil?
      @driver.action.move_to(element).perform
    else
      @driver.action.move_to(element, x, y).perform
    end
  end
end

class KeyboardActions
  def initialize(driver)
    @driver = driver
  end

  def send_keys(element, value)
    element.send_keys(value)
  end
end

class ElementActions
  def initialize(driver)
    @driver = driver
  end

  def find_element(selector, element)
    @driver.find_element(selector, element)
  end

  def find_elements(selector, element)
    @driver.find_elements(selector, element)
  end

  def text(element)
    element.text
  end
end

class Wrapper
  def initialize(driver_path, browser = :chrome, timeout = 15)
    Selenium::WebDriver::Chrome::Service.driver_path = driver_path
    @driver = Selenium::WebDriver.for browser
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = timeout
    @mouse = MouseActions.new(@driver)
    @keyboard = KeyboardActions.new(@driver)
    @element = ElementActions.new(@driver)
  end

  def get(url)
    @driver.get(url)
  end

  def current_url
    @driver.current_url
  end

  def quit
    @driver.quit
  end

  def click(element)
    @mouse.click(element)
  end

  def move_to(element, x = nil, y = nil)
    @mouse.move_to(element, x, y)
  end

  def send_keys(element, value)
    @keyboard.send_keys(element, value)
  end

  def find_element(how, what)
    @element.find_element(how, what)
  end

  def find_elements(how, what)
    @element.find_elements(how, what)
  end
end